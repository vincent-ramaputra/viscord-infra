terraform {
  required_version = "1.15.9"

  # Runs remotely in HCP Terraform with dynamic credentials: the workspace assumes the
  # hcp-terraform-demo IAM role (TFC_AWS_PROVIDER_AUTH / TFC_AWS_RUN_ROLE_ARN workspace env vars).
  # That role was created by hand and isn't in terraform-bootstrap/ yet.
  cloud {
    organization = "vincent_solo_team"

    workspaces {
      name = "aws-demo"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
