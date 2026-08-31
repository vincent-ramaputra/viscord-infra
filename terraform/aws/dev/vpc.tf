module "dev_vpc" {
    source  = "app.terraform.io/vincent_solo_team/aws-vpc/aws"
    version = "0.10.1"

    region = "ap-southeast-3"
    availability_zones = ["ap-southeast-3a", "ap-southeast-3b", "ap-southeast-3c"]

    name = "dev-vpc"
    cidr_block = "10.0.0.0/16"
    create_nat_gateway = true
    private_subnets = [
        {
            name = "dev-app-private-1"
            cidr = "10.0.100.0/22"
        },
        {
            name = "dev-app-private-2"
            cidr = "10.0.104.0/22"
        },
    ]
    public_subnets = [
        {
            name = "dev-app-public-1"
            cidr = "10.0.0.0/24"
        }
    ]

    tags = {
        Terraform = "true",
        Environment = "dev"
    }
}

resource "aws_subnet" "vpn_subnet" {
    vpc_id = module.dev_vpc.vpc_id
    cidr_block = "10.0.108.0/24"
}