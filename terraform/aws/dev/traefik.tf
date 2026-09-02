resource "aws_iam_role" "traefik" {
    name = "traefik-dev"
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

resource "aws_iam_role_policy" "traefik" {
    role = aws_iam_role.traefik.id
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Action = [
                "route53:ChangeResourceRecordSets",
                "route53:ListResourceRecordSets",
                "ListHostedZonesByName"
            ]
            Resource = "*"
        }]
    })
}

resource "aws_eks_pod_identity_association" "traefik" {
    cluster_name = module.app_cluster.cluster_name
    service_account = "traefik"
    namespace = "traefik"
    role_arn = aws_iam_role.traefik.arn
}