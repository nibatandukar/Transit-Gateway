terraform {
  backend "s3" {
    bucket = "infra-auto-chcs-prod-tfstate"
    key    = "PROD/terraform.tfstate"
    region = "us-east-1"
  }
}

