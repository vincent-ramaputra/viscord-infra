resource "aws_iam_role" "cluster_role" {
    name = "dev-eks"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Action = "sts:AssumeRole",
                Effect = "Allow",
                Principal = { Service = "eks.amazonaws.com" }
            }
        ]
    })

    tags = {
        Terraform = "true"
        Environment = "dev"
    }
}

resource "aws_iam_role" "cluster_node_role" {
    name = "dev-eks-node"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Action = "sts:AssumeRole",
                Effect = "Allow",
                Principal = { Service = "ec2.amazonaws.com" }
            }
        ]
    })

    tags = {
        Terraform = "true"
        Environment = "dev"
    }
}
