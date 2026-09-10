module "app_cluster" {
    source = "terraform-aws-modules/eks/aws"

    name = "app-dev"
    kubernetes_version = "1.36"

    iam_role_arn = aws_iam_role.cluster_role.arn
    enable_cluster_creator_admin_permissions = true

    vpc_id = module.dev_vpc.vpc_id
    subnet_ids = module.dev_vpc.private_subnet_ids
    additional_security_group_ids  = [
        aws_security_group.app_dev_allow_vpn.id
    ]
    endpoint_public_access = true
    security_group_name = "app-dev-sg"

    addons = {
        vpc-cni = {
            most_recent = true
            before_compute = true
            configuration_values = jsonencode({
                env = {
                    ENABLE_PREFIX_DELEGATION = "true"
                    WARM_PREFIX_TARGET       = "1"
                }
            })
        }
        coredns = {
            addon_version = "v1.14.3-eksbuild.16"
        }
        kube-proxy = {
            addon_version = "v1.36.0-eksbuild.17"
        }
        eks-pod-identity-agent = {
            addon_version = "v1.4.0-eksbuild.2"
            before_compute = true
        }
        aws-ebs-csi-driver = {
            addon_version = "v1.65.0-eksbuild.1"
        }
        metrics-server = {
            addon_version = "v0.9.0-eksbuild.9"
        }
    }

    tags = {
        Terraform = "true",
        Environment = "dev"
    }
}

module "app_cluster_node_group_spot" {
    source = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
    version = "v21.25.0"
    
    name = "dev-app-nodes"
    cluster_name = module.app_cluster.cluster_name

    subnet_ids = module.dev_vpc.private_subnet_ids
    cluster_service_cidr = module.app_cluster.cluster_service_cidr
    vpc_security_group_ids = [module.app_cluster.node_security_group_id]

    instance_types = ["t3.large"]
    capacity_type = "SPOT"
    min_size = 1
    max_size = 3
    desired_size = 1


    cloudinit_pre_nodeadm = [{
        content_type = "application/node.eks.aws"
        content      = <<-EOT
            apiVersion: node.eks.aws/v1alpha1
            kind: NodeConfig
            spec:
            kubelet:
                config:
                maxPods: 110
        EOT
    }]

    tags = {
        Terraform = "true",
        Environment = "dev"
    }
}


resource "aws_eks_access_entry" "app_cluster_administrator" {
    cluster_name = module.app_cluster.cluster_name
    principal_arn = aws_iam_role.app_cluster_administrator.arn
}

resource "aws_eks_access_policy_association" "app_cluster_administrator" {
    cluster_name = module.app_cluster.cluster_name
    principal_arn = aws_iam_role.app_cluster_administrator.arn
    policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

    access_scope {
      type = "cluster"
    }
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_cluster" {
    security_group_id            = data.aws_security_group.app_db.id
    referenced_security_group_id = module.app_cluster.node_security_group_id
    ip_protocol                  = "tcp"
    from_port                    = 5432
    to_port                      = 5432
}