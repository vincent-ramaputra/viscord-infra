module "app_cluster" {
    source = "terraform-aws-modules/eks/aws"

    name = "app-dev"
    kubernetes_version = "1.36"

    iam_role_arn = aws_iam_role.cluster_role.arn

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
        }
    }

    eks_managed_node_groups = {
        spot = {
            name = "dev-app-nodes"
            instance_types = ["t3.medium"]
            capacity_type = "SPOT"
            min_size = 1
            max_size = 3
            desired_size = 1
        }
    }


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
