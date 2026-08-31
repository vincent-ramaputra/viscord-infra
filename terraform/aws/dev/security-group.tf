resource "aws_security_group" "app_dev_allow_vpn" {
    name = "app-dev-allow-vpn"
    
    vpc_id = module.dev_vpc.vpc_id
    
    tags = {
        Name = "app-dev-allow-vpn"
        Terraform = "true"
        Environment = "dev"
    }
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
    security_group_id = aws_security_group.app_dev_allow_vpn.id
    ip_protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_ipv4 = aws_subnet.vpn_subnet.cidr_block
}