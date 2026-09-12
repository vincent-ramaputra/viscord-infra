resource "aws_iam_role" "tempo" {
  name = "tempo-dev"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "pods.eks.amazonaws.com" }
      Action = [
        "sts:AssumeRole",
        "sts:TagSession"
      ]
    }]
  })
}

resource "aws_iam_role_policy" "tempo" {
  role = aws_iam_role.tempo.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = [
          data.aws_s3_bucket.observability_dev.arn
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
          "${data.aws_s3_bucket.observability_dev.arn}/*"
        ]
      },
    ]
  })
}

resource "aws_eks_pod_identity_association" "tempo" {
  cluster_name    = module.app_cluster.cluster_name
  service_account = "tempo"
  namespace       = "monitoring"
  role_arn        = aws_iam_role.tempo.arn
}
