# Bootstrap for HCP Terraform dynamic credentials, based on HashiCorp's
# official example:
# https://github.com/hashicorp/terraform-dynamic-credentials-setup-examples/tree/main/aws

data "tls_certificate" "tfc_certificate" {
  url = "https://${var.tfc_hostname}"
}

resource "aws_iam_openid_connect_provider" "tfc_provider" {
  url             = data.tls_certificate.tfc_certificate.url
  client_id_list  = [var.tfc_aws_audience]
  thumbprint_list = [data.tls_certificate.tfc_certificate.certificates[0].sha1_fingerprint]
}

resource "aws_iam_role" "tfc_role" {
  name = "hcp-terraform-${var.tfc_workspace_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.tfc_provider.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${var.tfc_hostname}:aud" = one(aws_iam_openid_connect_provider.tfc_provider.client_id_list)
          }
          StringLike = {
            "${var.tfc_hostname}:sub" = "organization:${var.tfc_organization_name}:project:${var.tfc_project_name}:workspace:${var.tfc_workspace_name}:run_phase:*"
          }
        }
      }
    ]
  })
}

# Scoped to exactly what the terraform-aws-vpc module manages (aws_vpc,
# aws_vpc_ipv4_cidr_block_association, aws_subnet) - extend as more modules
# are added to the dev workspace.
resource "aws_iam_policy" "tfc_policy" {
  name        = "hcp-terraform-${var.tfc_workspace_name}-vpc"
  description = "Least-privilege VPC/subnet permissions for the ${var.tfc_workspace_name} HCP Terraform workspace"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateVpc",
          "ec2:DeleteVpc",
          "ec2:DescribeVpcs",
          "ec2:DescribeVpcAttribute",
          "ec2:ModifyVpcAttribute",
          "ec2:AssociateVpcCidrBlock",
          "ec2:DisassociateVpcCidrBlock",
          "ec2:CreateSubnet",
          "ec2:DeleteSubnet",
          "ec2:DescribeSubnets",
          "ec2:ModifySubnetAttribute",
          "ec2:CreateTags",
          "ec2:DeleteTags",
          "ec2:DescribeTags",
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "tfc_policy_attachment" {
  role       = aws_iam_role.tfc_role.name
  policy_arn = aws_iam_policy.tfc_policy.arn
}
