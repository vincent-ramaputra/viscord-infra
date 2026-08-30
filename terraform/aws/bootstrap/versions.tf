terraform {
  required_version = ">= 1.0"

  # Deliberately local state, not an HCP Terraform remote workspace: this
  # config creates the OIDC trust that *other* workspaces use for dynamic
  # credentials, so it can't bootstrap itself the same way (chicken-and-egg).
  # Apply this once, by hand, with temporary AWS credentials.

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}
