# resource "aws_ec2_client_vpn_endpoint" "vpn" {
#     client_cidr_block = "172.16.0.0/22"
#     vpc_id = module.dev_vpc.vpc_id
#     server_certificate_arn = "arn:aws:acm:ap-southeast-3:409684965426:certificate/9bfb8d9b-9a66-4bec-b7dd-2062a02373ac"
#     split_tunnel = true
#     authentication_options {
#       type = "certificate-authentication"
#       root_certificate_chain_arn = "arn:aws:acm:ap-southeast-3:409684965426:certificate/33faa40d-ed5a-4e4b-b772-eb8c07ea2b3d"
#     }
#     connection_log_options {
#       enabled = false
#     }

#     tags = {
#         Name = "dev-vpn"
#         Terraform = "true"
#         Environment = "dev"
#     }
# }

# resource "aws_ec2_client_vpn_network_association" "vpn_association" {
#     client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
#     subnet_id = aws_subnet.vpn_subnet.id
# }

# resource "aws_ec2_client_vpn_authorization_rule" "authorize_dev_vpc" {
#   client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
#   target_network_cidr = module.dev_vpc.cidr_block
#   authorize_all_groups = true
# }