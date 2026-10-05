output "public_ip" {
  description = "Put this in compose .env as PUBLIC_IP"
  value       = aws_eip.demo.public_ip
}

output "domain" {
  description = "Put this in compose .env as DOMAIN"
  value       = local.app_fqdn
}

output "instance_id" {
  value = aws_instance.demo.id
}

output "ssm_session" {
  value = "aws ssm start-session --region ${var.region} --target ${aws_instance.demo.id}"
}

output "ssh" {
  value = var.ssh_key_name == null ? null : "ssh -i ~/.ssh/${var.ssh_key_name}.pem ubuntu@${aws_eip.demo.public_ip}"
}
