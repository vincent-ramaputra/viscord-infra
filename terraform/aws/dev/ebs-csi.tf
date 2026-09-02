resource "aws_iam_role" "ebs_csi" {
    name = "dev-ebs-csi-driver"
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

resource "aws_iam_role_policy_attachment" "ebs_csi" {
    role = aws_iam_role.ebs_csi.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_eks_pod_identity_association" "ebs_csi" {
    cluster_name = module.app_cluster.cluster_name
    service_account = "ebs-csi-controller-sa"
    namespace = "kube-system"
    role_arn = aws_iam_role.ebs_csi.arn
}
