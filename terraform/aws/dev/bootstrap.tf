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


resource "helm_release" "external_secrets" {
    repository = "https://charts.external-secrets.io"
    chart = "external-secrets"
    name = "external-secrets"
    namespace = "external-secrets"
    create_namespace = true
}

resource "helm_release" "argocd" {
    repository = "https://argoproj.github.io/argo-helm"
    chart = "argo-cd"
    name = "argocd"
    namespace = "argocd"
    create_namespace = true
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
        helm_release.argocd,
        helm_release.external_secrets
    ]
}