data "aws_route53_zone" "main" {
  name = var.zone_name
}

locals {
  app_fqdn = "${var.subdomain}.${var.zone_name}"
  sfu_fqdn = "sfu.${local.app_fqdn}"
}

# external-dns in the dev cluster also writes to this zone, but it only touches records it owns
# (marked by its TXT records), so these are safe from it.
resource "aws_route53_record" "app" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = local.app_fqdn
  type    = "A"
  ttl     = 300
  records = [aws_eip.demo.public_ip]
}

resource "aws_route53_record" "sfu" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = local.sfu_fqdn
  type    = "A"
  ttl     = 300
  records = [aws_eip.demo.public_ip]
}
