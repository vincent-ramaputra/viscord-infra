variable "region" {
  description = "AWS region to bootstrap in. IAM/OIDC resources are global, but the provider still needs one."
  type        = string
  default     = "us-east-1"
}

variable "tfc_hostname" {
  description = "Hostname of the HCP Terraform / Terraform Enterprise instance"
  type        = string
  default     = "app.terraform.io"
}

variable "tfc_aws_audience" {
  description = "Audience value HCP Terraform uses in run identity tokens"
  type        = string
  default     = "aws.workload.identity"
}

variable "tfc_organization_name" {
  description = "HCP Terraform organization name"
  type        = string
  default     = "vincent_solo_team"
}

variable "tfc_project_name" {
  description = "HCP Terraform project the workspace belongs to. Must match exactly (case-sensitive) or the OIDC trust condition will silently reject the run with AccessDenied - verify this against the workspace's actual project in the HCP Terraform UI before applying."
  type        = string
  default     = "viscord"
}

variable "tfc_workspace_name" {
  description = "HCP Terraform workspace allowed to assume this role"
  type        = string
  default     = "aws-dev"
}
