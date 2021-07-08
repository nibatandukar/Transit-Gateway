provider "aws" {
  region = "ap-south-1"
}

module "vpc1" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"
  name = "my-vpc"
  cidr = "10.10.0.0/16"
  azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  private_subnets = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  enable_ipv6                                    = false
  private_subnet_assign_ipv6_address_on_creation = false
  private_subnet_ipv6_prefixes                   = [0, 1, 2]
  tags = {
    Name = "vpc1"
  }
}

