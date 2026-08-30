# module "app_nlb" {
#     source = "terraform-aws-modules/alb/aws"

#     name = "app-lb"
#     load_balancer_type = "network"
#     vpc_id = module.dev_vpc.vpc_id
#     subnets = module.dev_vpc.public_subnet_ids
#     listeners = {
#         app = {
#             port = 80
#             protocol = "tcp"
#         }
#     }
# }