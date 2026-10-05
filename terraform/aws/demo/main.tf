# Single-EC2 demo of Viscord running ../../../compose (Docker Compose).
# Independent of the aws-dev stack: it uses the default VPC, so `terraform destroy` on either
# stack never touches the other. The only shared things are the app S3 bucket and the DNS zone,
# which are both read with data sources, not managed here.

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Terraform   = "true"
      Environment = "demo"
    }
  }
}
