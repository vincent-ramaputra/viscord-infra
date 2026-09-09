resource "aws_iam_role" "s3_contributor" {
    name = "s3-contributor-dev"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Principal = { Service = "pods.eks.amazonaws.com" }
            Action = [
                "sts:AssumeRole",
                "sts:TagSession"
            ]
        }]
    })

    tags = {
        Terraform = "true"
        Environment = "dev"
    }
}

resource "aws_iam_role_policy" "s3_contributor" {
    role = aws_iam_role.s3_contributor.id
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Action = [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ]
            
            Resource = [
                data.aws_s3_bucket.app_dev.arn
            ]
        }]
    })
}

resource "aws_eks_pod_identity_association" "guild_service" {
    cluster_name = module.app_cluster.cluster_name
    service_account = "guild-ksa"
    namespace = "default"
    role_arn = aws_iam_role.s3_contributor.arn
}