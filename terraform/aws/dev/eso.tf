resource "aws_iam_role" "eso" {
    name = "dev-external-secrets"
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

resource "aws_iam_role_policy" "eso" {
    role = aws_iam_role.eso.id
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Action = [
                "secretsmanager:GetSecretValue",
                "secretsmanager:BatchGetSecretValue",
                "secretsmanager:ListSecrets"
            ]
            Resource = "arn:aws:secretsmanager:ap-southeast-3:409684965426:secret:viscord-dev-github-app-key-GLq1Vu"
        }]
    })
}

resource "aws_eks_pod_identity_association" "eso" {
    cluster_name = module.app_cluster.cluster_name
    service_account = "external-secrets"
    namespace = "external-secrets"
    role_arn = aws_iam_role.eso.arn
}