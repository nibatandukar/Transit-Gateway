terraform {
  backend "s3" {
    bucket = "synoptek-test-tgw-account1"
    key = "terraform.tfstate"
    region = "ap-south-1"
  }
}
