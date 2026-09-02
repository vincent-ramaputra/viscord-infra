output "role_arn" {
  description = "Set this as TFC_AWS_RUN_ROLE_ARN on the HCP Terraform workspace"
  value       = aws_iam_role.tfc_role.arn
}
