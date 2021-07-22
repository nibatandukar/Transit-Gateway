 
/*
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "my-vpc"

  cidr = "10.10.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  private_subnets = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]

  enable_ipv6                                    = true
  private_subnet_assign_ipv6_address_on_creation = true
  private_subnet_ipv6_prefixes                   = [0, 1, 2]
}
*/
/*
module "vpc1" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "my-vpc"

  cidr = "10.1.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]

  enable_ipv6                                    = true
  private_subnet_assign_ipv6_address_on_creation = true
  private_subnet_ipv6_prefixes                   = [0, 1, 2]
}

module "vpc2" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "my-vpc"

  cidr = "10.2.0.0/16"

  azs             = ["us-west-1a", "us-west-1c"]
  private_subnets = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]

  enable_ipv6                                    = true
  private_subnet_assign_ipv6_address_on_creation = true
  private_subnet_ipv6_prefixes                   = [0, 1, 2]
}
*/


data "aws_vpc" "vpc1" {
  filter {
    name   = "tag:Name"
    values = ["vpc1"]
  }
}
data "aws_vpc" "vpc2" {
  filter {
    name   = "tag:Name"
    values = ["vpc2"]
  }
}



/*
#data "aws_vpc" "vpc1" {
#  id = "vpc-038da825b7da2396e"
#}
*/


data "aws_subnet_ids" "vpc1" {
  vpc_id  = data.aws_vpc.vpc1.id
}
data "aws_subnet_ids" "vpc2" {
  vpc_id  = data.aws_vpc.vpc2.id
}

module "tgw" {
  source  = "terraform-aws-modules/transit-gateway/aws"
  version = "~> 2.0"

  name        = "my-tgw"
  description = "My TGW shared with several other AWS accounts"

  enable_auto_accept_shared_attachments = true

  vpc_attachments = {
    vpc1 = {
      #vpc_id       = module.vpc.vpc_id
      vpc_id       = data.aws_vpc.vpc1.id
      subnet_ids   = data.aws_subnet_ids.vpc1.ids
      dns_support  = true
      ipv6_support = true

      tgw_routes = [
        {
          destination_cidr_block = "10.0.0.0/8"
        },
        {
          blackhole = true
          destination_cidr_block = "0.0.0.0/0"
        }
      ]
    }

/*
   vpc1 = {
      vpc_id       = module.vpc1.vpc_id
      subnet_ids   = module.vpc1.private_subnets
      dns_support  = true
      ipv6_support = true

      tgw_routes = [
        {
          destination_cidr_block = "10.0.0.0/8"
        },
        {
          blackhole = true
          destination_cidr_block = "0.0.0.0/0"
        }
      ]
    },
*/ 
   vpc2 = {
      vpc_id       = data.aws_vpc.vpc2.id
      subnet_ids   = data.aws_subnet_ids.vpc2.ids
      dns_support  = true
      ipv6_support = true

      tgw_routes = [
        {
          destination_cidr_block = "10.2.0.0/16"
        },
        {
          blackhole = true
          destination_cidr_block = "30.0.0.0/8"
        }
      ]
    },

  }

  ram_allow_external_principals = true
  ram_principals = [307990089504]

  tags = {
    Purpose = "tgw-complete-example"
  }
}

