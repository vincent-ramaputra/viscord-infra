resource "aws_iam_role" "user_service" {
    name = "user-service-dev"
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

resource "aws_iam_role_policy" "user_service" {
    role = aws_iam_role.user_service.id
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Action = [
                "s3:ListBucket",
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

resource "aws_eks_pod_identity_association" "user_service" {
    cluster_name = module.app_cluster.cluster_name
    service_account = "user-ksa"
    namespace = "default"
    role_arn = aws_iam_role.user_service.arn
}

resource "aws_iam_role" "guild_service" {
    name = "guild-service-dev"
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

resource "aws_iam_role_policy" "guild_service" {
    role = aws_iam_role.guild_service.id
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Action = [
                "s3:ListBucket",
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
    role_arn = aws_iam_role.guild_service.arn
}