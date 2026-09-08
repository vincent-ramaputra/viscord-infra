data "aws_eks_cluster_auth" "app"{
    name = module.app_cluster.cluster_name
}

data "aws_ecr_authorization_token" "charts"{ }

provider "helm" {
    kubernetes = {
      host = module.app_cluster.cluster_endpoint
      cluster_ca_certificate = base64decode(module.app_cluster.cluster_certificate_authority_data)
      token = data.aws_eks_cluster_auth.app.token
    }
    registries = [ {
      url = "oci://409684965426.dkr.ecr.ap-southeast-3.amazonaws.com"
      username = data.aws_ecr_authorization_token.charts.user_name
      password = data.aws_ecr_authorization_token.charts.password
    } ]
}

provider "kubernetes" {
    host = module.app_cluster.cluster_endpoint
    cluster_ca_certificate = base64decode(module.app_cluster.cluster_certificate_authority_data) 
    token = data.aws_eks_cluster_auth.app.token
}

resource "helm_release" "external_secrets" {
    repository = "https://charts.external-secrets.io"
    chart = "external-secrets"
    name = "external-secrets"
    namespace = "external-secrets"
    create_namespace = true

    depends_on = [
        module.app_cluster_node_group_spot
    ]
}

resource "helm_release" "argocd" {
    repository = "https://argoproj.github.io/argo-helm"
    chart = "argo-cd"
    name = "argocd"
    namespace = "argocd"
    create_namespace = true

    depends_on = [
        module.app_cluster_node_group_spot
    ]
}

resource "helm_release" "app-bootstrap" {
    chart = "oci://409684965426.dkr.ecr.ap-southeast-3.amazonaws.com/charts/app-bootstrap"
    name = "app-bootstrap"
    version = "0.2.4"

    values = [yamlencode({
        secretStore = {
            region = "ap-southeast-3"
        }
        githubApp = {
            url = "https://github.com/Laevateinn17/viscord-infra.git"
            secretKey = "viscord-dev-github-app-key"
        }
    })]

    depends_on = [
        module.app_cluster_node_group_spot,
        helm_release.argocd,
        helm_release.external_secrets
    ]
}

resource "kubernetes_config_map_v1" "db_config" {
    metadata {
        name = "db-config"
    }

    data = {
        DB_HOST = data.aws_db_instance.app_db.address
        DB_PORT = data.aws_db_instance.app_db.port
    }
}