resource "aws_iam_role" "loki" {
    name = "loki-dev"
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
}

resource "aws_iam_role_policy" "loki" {
    role = aws_iam_role.loki.id
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "s3:ListBucket"
                ]
                Resource = [
                    data.aws_s3_bucket.loki_dev.arn
                ]
            },
            {
                Effect = "Allow"
                Action = [
                    "s3:GetObject",
                    "s3:PutObject",
                    "s3:DeleteObject"
                ]
                Resource = [
                    "${data.aws.s3_bucket.loki_dev.arn}/*"
                ]
            },

        ]
    })
}

resource "aws_eks_pod_identity_association" "eso" {
    cluster_name = module.app_cluster.cluster_name
    service_account = "loki-ksa"
    namespace = "loki"
    role_arn = aws_iam_role.loki.arn
}