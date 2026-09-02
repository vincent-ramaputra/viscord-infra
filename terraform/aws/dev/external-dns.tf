resource "aws_iam_role" "externaldns" {
    name = "external-dns-dev"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow",
            Principal = { Service = "pods.eks.amazonaws.com" }
            Action = [
                "sts:AssumeRole",
                "sts:TagSession"
            ]
        }]
    })

    tags = {
        Terraform = true,
        Environment = "dev"
    }
}

resource "aws_iam_role_policy" "externaldns" {
    role = aws_iam_role.externaldns.id
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow",
            Action = [
                "route53:ChangeResourceRecordSets",
                "route53:ListResourceRecordSets",
                "route53:ListTagsForResources"
            ],
            Resource = "*"
        }]       
    })
}

resource "aws_eks_pod_identity_association" "externaldns" {
    cluster_name = module.app_cluster.cluster_name
    service_account = "external-dns"
    namespace = "external-dns"
    role_arn = aws_iam_role.externaldns
}