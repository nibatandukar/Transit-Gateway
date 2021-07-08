module "vpc1" {
  source  = "./../vpc-module"
  name = "my-vpc"
  cidr = "10.1.0.0/16"
  azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  enable_ipv6                                    = true
  private_subnet_assign_ipv6_address_on_creation = true
  private_subnet_ipv6_prefixes                   = [0, 1, 2]
  tgw-route-cidr                                 = "10.10.0.0/16"
  transit_gateway_id                             = "tgw-0d107e3805b38503d"
  tags = {
    Name = "vpc1"
  }
}
