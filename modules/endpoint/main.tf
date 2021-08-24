provider "aws" {
  region = "us-west-2"
}


provider "aws" {
  region = "us-west-2"
  alias  = "chris-dr"
   assume_role {
     role_arn = "arn:aws:iam::150567456321:role/automation-to-chris-dr"
  }
}

provider "aws" {
  region = "us-west-2"
  alias  = "mark-dr"
   assume_role {
     role_arn = "arn:aws:iam::530420366225:role/automation-to-mark-dr"
  }
}

provider "aws" {
  alias                   = "automation-dr"
  region                  = "us-west-2"
  assume_role {
    role_arn = "arn:aws:iam::734084427358:role/aumation-to-automation-dr"
  }
}


data "aws_caller_identity" "mark-dr" {
  provider = aws.mark-dr
}

data "aws_caller_identity" "chris-dr" {
 provider = aws.chris-dr
}

data "aws_caller_identity" "automation-dr" {
 provider = aws.automation-dr
}

module "tgw" {
  source = "terraform-aws-modules/transit-gateway/aws"
  providers = {
    aws = aws.automation-dr
  }

  name            = "my-tgw-dr"
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
    aws = aws.mark-dr
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
      subnet_ids                                      = module.vpc2.private_subnets_0
      dns_support                                     = true
    #  ipv6_support                                    = true
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
/*
module "tgw_peer_chris" {
  source = "terraform-aws-modules/transit-gateway/aws"

  providers = {
    aws = aws.chris-dr
  }

  name            = "my-tgw-peer-chris"
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
      subnet_ids                                      = module.vpc3.private_subnets_0
     # subnet_ids                                      = data.aws_subnet_ids.this.ids # module.vpc1.private_subnets
      dns_support                                     = true
     # ipv6_support                                    = true
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
*/
module "vpc2" {
  source  = "./../modules/vpc-module"

  name = "vpc2-mark-dr"

  cidr = "10.50.0.0/16"
  azs             = ["us-west-2a", "us-west-2b"]
  public_subnets  = ["10.50.10.0/26", "10.50.10.64/26", "10.50.30.0/26", "10.50.30.64/26", "10.50.20.0/26", "10.50.20.64/26", "10.50.40.0/26", "10.50.40.64/26", "10.50.50.0/26", "10.50.50.64/26", "10.50.60.0/26", "10.50.60.64/26"]
  private_subnets = ["10.50.10.128/26", "10.50.10.192/26", "10.50.30.128/26", "10.50.30.192/26", "10.50.20.128/26", "10.50.20.192/26", "10.50.40.128/26", "10.50.40.192/26", "10.50.50.128/26", "10.50.50.192/26", "10.50.60.128/26", "10.50.60.192/26"]
  
#  enable_ipv6                                    = true
#  private_subnet_assign_ipv6_address_on_creation = true
#  private_subnet_ipv6_prefixes                   = [0, 1, 2]
  tgw-route-cidr-1                                 = "10.30.0.0/16"
#  tgw-route-cidr-2                                 = "10.2.0.0/16"
  transit_gateway_id                             = module.tgw.ec2_transit_gateway_id
 
  providers = {

    aws.dst = aws.mark-dr
  }

}
/*
module "vpc3" {
  source  = "./../modules/vpc-module"

  name = "vpc3-chris-dr"
  cidr = "10.30.0.0/16"

  azs             = ["us-west-2a", "us-west-2b"]
  public_subnets = ["10.30.20.0/26", "10.30.20.64/26", "10.30.30.0/26", "10.30.30.64/26", "10.30.40.0/26", "10.30.40.64/26", "10.30.50.0/26", "10.30.50.64/26"]
  private_subnets = ["10.30.20.128/26", "10.30.20.192/26", "10.30.30.128/26", "10.30.30.192/26", "10.30.40.128/26", "10.30.40.192/26", "10.30.50.128/26", "10.30.50.192/26"]

  #enable_ipv6                                    = true
  #private_subnet_assign_ipv6_address_on_creation = true
  #private_subnet_ipv6_prefixes                   = [0, 1, 2]
  
  tgw-route-cidr-1                                 = "10.50.0.0/16"
  #tgw-route-cidr-2                                 = "10.1.0.0/16"
  transit_gateway_id                             = module.tgw.ec2_transit_gateway_id
  
   providers = {

    aws.dst = aws.chris-dr
  }

}
*/
module "sg-tgw" {
  source = "./../modules/aws-sg-tgw"
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

    aws.dst = aws.mark-dr
  }

}
/*
module "sg-tgw-1" {
  source = "./../modules/aws-sg-tgw"
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

    aws.dst = aws.chris-dr
  }

}
*/
# EC2-Public
module "ec2-transit-gateway-public" {
  source                        = "./../modules/aws-ec2"
  key_name                      = "transit-gateway-mark-1"
  public_key                    = file("./niba.pub")
  instance_count                = 1
  ami                           = "ami-0dc8f589abe99f538"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "true"
  root_volume_size              = 8
  subnet_ids                    = module.vpc2.public_subnets
  vpc_security_group_ids        = [module.sg-tgw.aws_security_group]
  
  #iam_instance_profile          = "aws_iam_instance_profile.s3_profile.name"
 # iam_instance_profile          = "${aws_iam_instance_profile.s3_profile.name}"
  iam_instance_profile = module.s3-role.aws_iam_s3_role
 # iam_instance_profile = "s3_profile"
  ec2_tags                      = "MARk-EC2-VM1"
  providers = {
    aws.dst = aws.mark-dr
  }
  
}
/*
module "ec2-transit-gateway-public-1" {
  source                        = "./../modules/aws-ec2"
  key_name                      = "transit-gateway-chris-1"
  public_key                    = file("./niba.pub")
  instance_count                = 1
  ami                           = "ami-0dc8f589abe99f538"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "true"
  root_volume_size              = 8
  subnet_ids                    = module.vpc3.public_subnets
  vpc_security_group_ids        = [module.sg-tgw-1.aws_security_group]
  ec2_tags = "CHRIS-EC2-VM1"
  providers = {
    aws.dst = aws.chris-dr
  }

}
*/
/*   
module "ec2-private-chris" {
  source                        = "./../modules/aws-ec2"
  key_name                      = "transit-gateway-chris"
  public_key                    = file("./niba-prv.pub")
  instance_count                = 1
  ami                           = "ami-0dc8f589abe99f538"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "false"
  root_volume_size              = 8
  subnet_ids                    = module.vpc3.private_subnets
  vpc_security_group_ids        = [module.sg-tgw-1.aws_security_group]
  ec2_tags = "CHRIS-EC2-VM1-PRIVATE"
  providers = {
    aws.dst = aws.chris-dr
  }

}
*/
module "ec2-private-mark" {
  source                        = "./../modules/aws-ec2"
#  namespace                     = "cloud"
#  stage                         = "dev"
#  name                          = "transit-gateway-mark"
  key_name                      = "transit-gateway-mark"
  public_key                    = file("./niba-prv.pub")
  instance_count                = 1
  ami                           = "ami-0dc8f589abe99f538"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "false"
  root_volume_size              = 8
  subnet_ids                    = module.vpc2.private_subnets
  vpc_security_group_ids        = [module.sg-tgw.aws_security_group]
  ec2_tags = "MARK-EC2-VM1-PRIVATE"
  #iam_instance_profile = "s3_profile"
  #iam_instance_profile = "${aws_iam_instance_profile.s3_profile.name}"
  iam_instance_profile = module.s3-role.aws_iam_s3_role
  providers = {
    aws.dst = aws.mark-dr
  }

}

module "s3-role" {
  source     ="./../modules/s3-role"   
  providers = {
    aws = aws.mark-dr
  }
}

##############################################

module "vpc_endpoints" {
  #source = "cloudposse/vpc/aws//modules/vpc-endpoints"
  source = "./../modules/vpc-endpoints"

  vpc_id = module.vpc2.vpc_id

  gateway_vpc_endpoints = {
    "s3" = {
      name = "s3"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action = [
              "s3:*",
            ]
            Effect    = "Allow"
            Principal = "*"
            Resource  = "*"
          },
        ]
      })
      route_table_ids     = module.vpc2.private_route_table_ids
    }
  }

#  interface_vpc_endpoints = {
#    "ec2" = {
#      name                = "ec2"
#      security_group_ids  = [module.sg-tgw.aws_security_group] 
#      subnet_ids          = module.vpc2.private_subnets
#      policy              = null
#      private_dns_enabled = false
#    }
#  }

 providers = {

    aws = aws.mark-dr
  }

}

