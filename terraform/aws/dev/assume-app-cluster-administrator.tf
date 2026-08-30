resource "aws_iam_group_policy" "assume_appcluster_administrator" {
    name = "AssumeDevAppClusterAdministrator"
    group = "DevOps"
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole",
                Effect = "Allow",
                Resource = [
                    aws_iam_role.app_cluster_administrator.arn
                ]
            }
        ]
    })
}