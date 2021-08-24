terraform {
  backend "s3" {
    bucket = "infra-auto-chcs-dr-tfstate"
    key    = "DR/terraform.tfstate"
    region = "us-west-2"
  }
}

