data "aws_s3_bucket" "app_dev" {
    bucket = "viscord-dev-409684965426-ap-southeast-3-an"
}

data "aws_s3_bucket" "observability_dev" {
    bucket = "viscord-observability-dev"
}
