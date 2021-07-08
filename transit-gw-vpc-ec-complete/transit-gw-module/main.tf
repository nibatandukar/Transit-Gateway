
provider "aws" {
  region = "ap-south-1"
}


provider "aws" {
  region = "ap-south-1"
  alias  = "automation"
   assume_role {
     role_arn = "arn:aws:iam::734084427358:role/CrossAccountPowerUser4"
  }
}

provider "aws" {
  region = "ap-south-1"
  alias  = "mark"
   assume_role {
     role_arn = "arn:aws:iam::530420366225:role/CrossAccountPowerUser2"
  }
}

provider "aws" {
  alias                   = "chris"
  region                  = "ap-south-1"
  assume_role {
    role_arn = "arn:aws:iam::150567456321:role/CrossAccountPowerUser1"
  }
}


data "aws_caller_identity" "mark" {
  provider = aws.mark
}

data "aws_caller_identity" "chris" {
 provider = aws.chris
}

data "aws_caller_identity" "automation" {
 provider = aws.automation
}

module "tgw" {
  source = "terraform-aws-modules/transit-gateway/aws"

  name            = "my-tgw"
  description     = "My TGW shared with several other AWS accounts"
  amazon_side_asn = 64532

  enable_auto_accept_shared_attachments = true # When "true" there is no need for RAM resources if using multiple AWS accounts
/*
  vpc_attachments = {
    vpc1 = {
      vpc_id     = module.vpc1.vpc_id
      subnet_ids = module.vpc1.private_subnets
      tgw_routes = [
        {
          destination_cidr_block = "50.0.0.0/16"
        },
        {
          blackhole              = true
          destination_cidr_block = "10.10.10.10/32"
        }
      ]
    }
  }
*/
  ram_allow_external_principals = true
  ram_principals                = [150567456321,530420366225]

  tags = {
    Purpose = "tgw-complete-example"
  }
}

module "tgw_peer" {
  source = "terraform-aws-modules/transit-gateway/aws"

  providers = {
    aws = aws.mark
  }

  name            = "my-tgw-peer"
  description     = "My TGW shared with several other AWS accounts"
  amazon_side_asn = 64532

  share_tgw                             = true
  create_tgw                            = false
  ram_resource_share_arn                = module.tgw.ram_resource_share_id
  enable_auto_accept_shared_attachments = true # When "true" there is no need for RAM resources if using multiple AWS accounts

  vpc_attachments = {
    vpc2 = {
      tgw_id                                          = module.tgw.ec2_transit_gateway_id
      vpc_id                                          = module.vpc2.vpc_id
      subnet_ids                                      = module.vpc2.private_subnets
      dns_support                                     = true
      ipv6_support                                    = true
     #transit_gateway_default_route_table_association = false
     #transit_gateway_default_route_table_propagation = false
      #      transit_gateway_route_table_id = "tgw-rtb-073a181ee589b360f"

   #   tgw_routes = [
   #     {
   #       destination_cidr_block = "30.0.0.0/16"
   #     },
   #     {
   #       blackhole              = true
   #       destination_cidr_block = "0.0.0.0/0"
   #     }
   #   ]
    }
  }

  ram_allow_external_principals = true

  ram_principals                = [530420366225]
  tags = {
    Purpose = "tgw-complete-example"
  }
}

module "tgw_peer_chris" {
  source = "terraform-aws-modules/transit-gateway/aws"

  providers = {
    aws = aws.chris
  }

  name            = "my-tgw-peer-mark"
  description     = "My TGW shared with several other AWS accounts"
  amazon_side_asn = 64532

  share_tgw                             = true
  create_tgw                            = false
  ram_resource_share_arn                = module.tgw.ram_resource_share_id
  enable_auto_accept_shared_attachments = true # When "true" there is no need for RAM resources if using multiple AWS accounts

  vpc_attachments = {
    vpc3 = {
      tgw_id                                          = module.tgw.ec2_transit_gateway_id
      vpc_id                                          = module.vpc3.vpc_id
     # vpc_id                                          = data.aws_vpc.default.id      # module.vpc1.vpc_id
      subnet_ids                                      = module.vpc3.private_subnets
     # subnet_ids                                      = data.aws_subnet_ids.this.ids # module.vpc1.private_subnets
      dns_support                                     = true
      ipv6_support                                    = true
     #transit_gateway_default_route_table_association = false
     #transit_gateway_default_route_table_propagation = false
      #      transit_gateway_route_table_id = "tgw-rtb-073a181ee589b360f"

   #   tgw_routes = [
   #     {
   #       destination_cidr_block = "30.0.0.0/16"
   #     },
   #     {
   #       blackhole              = true
   #       destination_cidr_block = "0.0.0.0/0"
   #     }
   #   ]
    }
  }

  ram_allow_external_principals = true
  ram_principals                = [150567456321]

  tags = {
    Purpose = "tgw-complete-example"
  }
}

module "vpc2" {
  source  = "./modules/vpc-module"

  name = "vpc2"

  cidr = "10.1.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  
  public_subnets  = ["10.1.5.0/24", "10.1.6.0/24", "10.1.7.0/24"]
  enable_ipv6                                    = true
  private_subnet_assign_ipv6_address_on_creation = true
  private_subnet_ipv6_prefixes                   = [0, 1, 2]
  tgw-route-cidr-1                                 = "10.10.0.0/16"
  tgw-route-cidr-2                                 = "10.2.0.0/16"
  transit_gateway_id                             = module.tgw.ec2_transit_gateway_id
 
  providers = {

    aws.dst = aws.mark
  }

}
module "vpc3" {
  source  = "./modules/vpc-module"

  name = "vpc3"

  cidr = "10.2.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  private_subnets = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]

  public_subnets  = ["10.2.8.0/24", "10.2.9.0/24", "10.2.11.0/24"]
  enable_ipv6                                    = true
  private_subnet_assign_ipv6_address_on_creation = true
  private_subnet_ipv6_prefixes                   = [0, 1, 2]
  
  tgw-route-cidr-1                                 = "10.10.0.0/16"
  tgw-route-cidr-2                                 = "10.1.0.0/16"
  transit_gateway_id                             = module.tgw.ec2_transit_gateway_id
  
   providers = {

    aws.dst = aws.chris
  }

}

module "sg-tgw" {
  source = "./modules/aws-sg-tgw"
  security_group_name = "TGW-sg"
  vpc_id = module.vpc2.vpc_id

  # Rule-1
  ingress-rule-1-from-port = 22
  ingress-rule-1-to-port = 22
  ingress-rule-1-protocol = "tcp"
  ingress-rule-1-cidrs = ["0.0.0.0/0"]
  ingress-rule-1-description = "SHH PORT"


  # Rule-3
  ingress-rule-3-from-port   = -1
  ingress-rule-3-to-port     = -1
  ingress-rule-3-protocol    = "icmp"
  ingress-rule-3-cidrs       = ["0.0.0.0/0"]
  ingress-rule-3-description = "Ingress Rule"
  providers = {

    aws.dst = aws.mark
  }

}
module "sg-tgw-1" {
  source = "./modules/aws-sg-tgw"
  security_group_name = "TGW-sg"
  vpc_id = module.vpc3.vpc_id

  # Rule-1
  ingress-rule-1-from-port = 22
  ingress-rule-1-to-port = 22
  ingress-rule-1-protocol = "tcp"
  ingress-rule-1-cidrs = ["0.0.0.0/0"]
  ingress-rule-1-description = "SHH PORT"


  # Rule-3
  ingress-rule-3-from-port   = -1
  ingress-rule-3-to-port     = -1
  ingress-rule-3-protocol    = "icmp"
  ingress-rule-3-cidrs       = ["0.0.0.0/0"]
  ingress-rule-3-description = "Ingress Rule"
  providers = {

    aws.dst = aws.chris
  }

}
# EC2-Public
module "ec2-transit-gateway-public" {
  source                        = "./modules/aws-ec2"
  key_name                      = "transit-gateway"
  public_key                    = file("./niba.pub")
  instance_count                = 1
  ami                           = "ami-011c99152163a87ae"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "true"
  root_volume_size              = 8
  subnet_ids                    = module.vpc2.public_subnets
  vpc_security_group_ids        = [module.sg-tgw.aws_security_group]
  ec2_tags = "MARk-EC2-VM1"
  providers = {
    aws.dst = aws.mark
  }
  
}
module "ec2-transit-gateway-public-1" {
  source                        = "./modules/aws-ec2"
  key_name                      = "transit-gateway"
  public_key                    = file("./niba.pub")
  instance_count                = 1
  ami                           = "ami-011c99152163a87ae"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "true"
  root_volume_size              = 8
  subnet_ids                    = module.vpc3.public_subnets
  vpc_security_group_ids        = [module.sg-tgw-1.aws_security_group]
  ec2_tags = "CHRIS-EC2-VM1"
  providers = {
    aws.dst = aws.chris
  }

}
     
module "ec2-private-chris" {
  source                        = "./modules/aws-ec2"
  key_name                      = "transit-gateway-chris"
  public_key                    = file("./niba-prv.pub")
  instance_count                = 1
  ami                           = "ami-011c99152163a87ae"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "false"
  root_volume_size              = 8
  subnet_ids                    = module.vpc3.private_subnets
  vpc_security_group_ids        = [module.sg-tgw-1.aws_security_group]
  ec2_tags = "CHRIS-EC2-VM1-PRIVATE"
  providers = {
    aws.dst = aws.chris
  }

}
module "ec2-private-mark" {
  source                        = "./modules/aws-ec2"
#  namespace                     = "cloud"
#  stage                         = "dev"
#  name                          = "transit-gateway-mark"
  key_name                      = "transit-gateway-mark"
  public_key                    = file("./niba-prv.pub")
  instance_count                = 1
  ami                           = "ami-011c99152163a87ae"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "false"
  root_volume_size              = 8
  subnet_ids                    = module.vpc2.private_subnets
  vpc_security_group_ids        = [module.sg-tgw.aws_security_group]
  ec2_tags = "MARK-EC2-VM1-PRIVATE"
  providers = {
    aws.dst = aws.mark
  }

}

