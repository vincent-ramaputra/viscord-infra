resource "aws_iam_role" "app_cluster_administrator" {
    name = "dev_app_cluster_administrator"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Action = "sts:AssumeRole",
                Effect = "Allow",
                Principal = { AWS = "arn:aws:iam::409684965426:root" }
            }
        ]
    })

    tags = {
        Terraform = "true"
        Environment = "dev"
    }
}

resource "aws_iam_role_policy" "app_cluster_administrator_appcluster" {
    name = "dev-appcluster-policy"
    role = aws_iam_role.app_cluster_administrator.id
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "eks:DescribeCluster"
                ]
                Resource = [
                    module.app_cluster.cluster_arn
                ]
            }
        ]
    })
}