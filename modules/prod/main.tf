provider "aws" {
  region = var.region
}

provider "aws" {
  alias                   = "chcs-shared"
  region                  = var.region
  assume_role {
    role_arn = var.role_arn_shared
  }
}

provider "aws" {
  alias                   = "chcs-transit"
  region                  = var.region
  assume_role {
    role_arn = var.role_arn_transit
  }
}

provider "aws" {
  region = var.region
  alias  = "chcs-prod"
   assume_role {
     role_arn = var.role_arn_prod
  }
}

provider "aws" {
  region = var.region
  alias  = "chcs-non-prod"
   assume_role {
     role_arn = var.role_arn_non_prod
  }
}

provider "aws" {
  region = var.region
  alias  = "chcs-pci"
   assume_role {
     role_arn = var.role_arn_pci
  }
}

#################################################################
# TRANSIT GATEWAY IN TRANSIT ACCOUNT
#################################################################

module "tgw" {
  source = "terraform-aws-modules/transit-gateway/aws"
  providers = {
    aws = aws.chcs-transit
  }

  name            = var.name_transit_tgw
  description     = var.description_transit_tgw
  amazon_side_asn = var.amazon_side_asn_transit

  enable_auto_accept_shared_attachments = var.enable_auto_accept_shared_attachments_transit # When "true" there is no need for RAM resources if using multiple AWS accounts
  vpc_attachments = {
    INSPECTION-VPC-TRANSIT-PROD = {
      vpc_id     = module.INSPECTION-VPC-TRANSIT-PROD.vpc_id
      subnet_ids = module.INSPECTION-VPC-TRANSIT-PROD.private_subnets_0
    }
  }
  ram_allow_external_principals = var.ram_allow_external_principals
 # ram_principals                = [682258877194, 551294210778, 530420366225, 279108474419]
  ram_principals                = var.ram_principals_transit
  tags = {
    Purpose = var.tags_transit_purpose
  }
}

################################################################################
# TRANSIT GATEWAY IN PROD ACCOUNT
################################################################################

module "tgw_peer_prod" {
  source = "terraform-aws-modules/transit-gateway/aws"
  providers = {
    aws = aws.chcs-prod
  }
  name            = var.name_prod_tgwpeer
  description     = var.description_prod_tgw
  amazon_side_asn = var.amazon_side_asn_transit
  share_tgw                             = var.share_tgw
  create_tgw                            = var.create_tgw
  ram_resource_share_arn                = module.tgw.ram_resource_share_id
  enable_auto_accept_shared_attachments = var.enable_auto_accept_shared_attachments_transit # When "true" there is no need for RAM resources if using multiple AWS accounts
  vpc_attachments = {
    SHARED-CHCS-VPC-PROD = {
      tgw_id                                          = module.tgw.ec2_transit_gateway_id
      vpc_id                                          = module.SHARED-CHCS-VPC-PROD.vpc_id
      subnet_ids                                      = module.SHARED-CHCS-VPC-PROD.public_subnets_0
      dns_support                                     = var.dns_support
    },
    HIPAA-CHCS-VPC-PROD = {
      tgw_id                                          = module.tgw.ec2_transit_gateway_id
      vpc_id                                          = module.HIPAA-CHCS-VPC-PROD.vpc_id
      subnet_ids                                      = module.HIPAA-CHCS-VPC-PROD.public_subnets_0
      dns_support                                     = var.dns_support
    }
  }

  ram_allow_external_principals = var.ram_allow_external_principals
  ram_principals                = var.ram_principals_prod
  tags = {
    Purpose = var.tags_prod_purpose
  }
}

################################################################################
# TRANSIT GATEWAY IN NON-PROD ACCOUNT
################################################################################

module "tgw_peer_nonprod" {
  source = "terraform-aws-modules/transit-gateway/aws"
  providers = {
    aws = aws.chcs-non-prod
  }
  name            = var.name_non_prod_tgwpeer
  description     = var.description_non_prod_tgw
  amazon_side_asn = var.amazon_side_asn_transit
  share_tgw                             = var.share_tgw
  create_tgw                            = var.create_tgw
  ram_resource_share_arn                = module.tgw.ram_resource_share_id
  enable_auto_accept_shared_attachments = var.enable_auto_accept_shared_attachments_transit # When "true" there is no need for RAM resources if using multiple AWS accounts
  vpc_attachments = {
    PCI-CHCS-VPC-NON-PROD = {
      tgw_id                                          = module.tgw.ec2_transit_gateway_id
      vpc_id                                          = module.PCI-CHCS-VPC-NON-PROD.vpc_id
      subnet_ids                                      = module.PCI-CHCS-VPC-NON-PROD.public_subnets_0
      dns_support                                     = var.dns_support
    },
    HIPAA-CHCS-VPC-NON-PROD = {
      tgw_id                                          = module.tgw.ec2_transit_gateway_id
      vpc_id                                          = module.HIPAA-CHCS-VPC-NON-PROD.vpc_id
      subnet_ids                                      = module.HIPAA-CHCS-VPC-NON-PROD.public_subnets_0
      dns_support                                     = var.dns_support
    },
    DEV-QA-UAT-CHCS-VPC-NON-PROD = {
      tgw_id                                          = module.tgw.ec2_transit_gateway_id
      vpc_id                                          = module.DEV-QA-UAT-CHCS-VPC-NON-PROD.vpc_id
      subnet_ids                                      = module.DEV-QA-UAT-CHCS-VPC-NON-PROD.public_subnets_0
      dns_support                                     = var.dns_support
    }
  }

  ram_allow_external_principals = var.ram_allow_external_principals
  ram_principals                = var.ram_principals_non_prod
  tags = {
    Purpose = var.tags_non_prod_purpose
  }
}

#############################################################################
# TRANSIT GATEWAY IN PCI CHCS ACCOUNT
#############################################################################

module "tgw_peer_pci" {
  source = "terraform-aws-modules/transit-gateway/aws"
  providers = {
    aws = aws.chcs-pci
  }
  name            = var.name_pci_tgwpeer
  description     = var.description_pci_tgw
  amazon_side_asn = var.amazon_side_asn_transit
  share_tgw                             = var.share_tgw
  create_tgw                            = var.create_tgw
  ram_resource_share_arn                = module.tgw.ram_resource_share_id
  enable_auto_accept_shared_attachments = var.enable_auto_accept_shared_attachments_transit # When "true" there is no need for RAM resources if using multiple AWS accounts
  vpc_attachments = {
    PCI-CHCS-VPC-PCI = {
      tgw_id                                          = module.tgw.ec2_transit_gateway_id
      vpc_id                                          = module.PCI-CHCS-VPC-PCI.vpc_id
      subnet_ids                                      = module.PCI-CHCS-VPC-PCI.public_subnets_0
      dns_support                                     = var.dns_support
    }
  }

  ram_allow_external_principals = var.ram_allow_external_principals
  ram_principals                = var.ram_principals_pci
  #ram_principals                = [982631031626]
  tags = {
    Purpose = var.tags_pci_purpose
  }
}

#############################################################################
# SHARED SERVICE ACCOUNT
#############################################################################

module "tgw_peer_shared" {
  source = "terraform-aws-modules/transit-gateway/aws"
  providers = {
    aws = aws.chcs-shared
  }
  name            = "TGW-PEER-SHARED"
  description     = "My TGW shared with several other AWS accounts"
  amazon_side_asn = var.amazon_side_asn_transit
  share_tgw                             = var.share_tgw
  create_tgw                            = var.create_tgw
  ram_resource_share_arn                = module.tgw.ram_resource_share_id
  enable_auto_accept_shared_attachments = var.enable_auto_accept_shared_attachments_transit # When "true" there is no need for RAM resources if using multiple AWS accounts
  vpc_attachments = {
    SHARED-SERVICE-CHCS-VPC = {
      tgw_id                                          = module.tgw.ec2_transit_gateway_id
      vpc_id                                          = module.SHARED-SERVICE-CHCS-VPC.vpc_id
      subnet_ids                                      = module.SHARED-SERVICE-CHCS-VPC.public_subnets_0
      dns_support                                     = var.dns_support
    },
    BASTION-VPC-SHARED-SERVICE = {
      tgw_id                                          = module.tgw.ec2_transit_gateway_id
      vpc_id                                          = module.BASTION-VPC-SHARED-SERVICE.vpc_id
      subnet_ids                                      = module.BASTION-VPC-SHARED-SERVICE.public_subnets_0
      dns_support                                     = var.dns_support
    }
  }

  ram_allow_external_principals = var.ram_allow_external_principals
  ram_principals                = var.ram_principals_shared
  tags = {
    Purpose = var.tags_shared_purpose
  }
}

###########################################################################################
#TRANSIT ACCOUNT VPC PROD
###########################################################################################

module "INSPECTION-VPC-TRANSIT-PROD" {
  source  = "./../modules/vpc-module-single"
  name = var.name_inspection_vpc_transit
  cidr = var.cidr_inspection_vpc_transit
  azs             = var.azs_inspection_vpc_transit
  private_subnets = var.private_subnets_inspection_vpc_transit
  public_subnets  = var.public_subnets_inspection_vpc_transit
  private_dedicated_network_acl = true
  public_dedicated_network_acl = true

  tgw-route-cidr-1  = var.tgw-route-cidr-1_inspection_vpc_transit
  tgw-route-cidr-2  = var.tgw-route-cidr-2_inspection_vpc_transit
  tgw-route-cidr-3  = var.tgw-route-cidr-3_inspection_vpc_transit
  tgw-route-cidr-4  = var.tgw-route-cidr-4_inspection_vpc_transit   
  tgw-route-cidr-5  = var.tgw-route-cidr-5_inspection_vpc_transit 
  tgw-route-cidr-6  = var.tgw-route-cidr-6_inspection_vpc_transit
  tgw-route-cidr-7  = var.tgw-route-cidr-7_inspection_vpc_transit
  tgw-route-cidr-8  = var.tgw-route-cidr-8_inspection_vpc_transit
 
  transit_gateway_id                             = module.tgw.ec2_transit_gateway_id
  providers = {
    aws.dst = aws.chcs-transit
  }
}



###########################################################################################
#PROD ACCOUNT VPC
###########################################################################################

module "SHARED-CHCS-VPC-PROD" {
  source  = "./../modules/vpc-module"
  name = var.name_shared_chcs_vpc_prod
  cidr = var.cidr_shared_chcs_vpc_prod
  azs             = var.azs_shared_chcs_vpc_prod
  private_subnets = var.private_subnets_shared_chcs_vpc_prod
  public_subnets  = var.public_subnets_shared_chcs_vpc_prod
  private_dedicated_network_acl = true
  public_dedicated_network_acl = true

  tgw-route-cidr-1   = var.tgw-route-cidr-1_shared_chcs_vpc_prod
  tgw-route-cidr-2   = var.tgw-route-cidr-2_shared_chcs_vpc_prod
  tgw-route-cidr-3   = var.tgw-route-cidr-3_shared_chcs_vpc_prod
  tgw-route-cidr-4   = var.tgw-route-cidr-4_shared_chcs_vpc_prod
  tgw-route-cidr-5   = var.tgw-route-cidr-5_shared_chcs_vpc_prod
  tgw-route-cidr-6   = var.tgw-route-cidr-6_shared_chcs_vpc_prod
  tgw-route-cidr-7   = var.tgw-route-cidr-7_shared_chcs_vpc_prod
  tgw-route-cidr-8   = var.tgw-route-cidr-8_shared_chcs_vpc_prod
  
  transit_gateway_id                               = module.tgw.ec2_transit_gateway_id
  providers = {
    aws.dst = aws.chcs-prod
  }
}


module "HIPAA-CHCS-VPC-PROD" {
  source  = "./../modules/vpc-module"
  name = var.name_hipaa_chcs_vpc_prod
  cidr = var.cidr_hipaa_chcs_vpc_prod
  azs             = var.azs_hipaa_chcs_vpc_prod
  private_subnets = var.private_subnets_hipaa_chcs_vpc_prod
  public_subnets  = var.public_subnets_hipaa_chcs_vpc_prod
  private_dedicated_network_acl = true
  public_dedicated_network_acl = true

  tgw-route-cidr-1  = var.tgw-route-cidr-1_hipaa_chcs_vpc_prod
  tgw-route-cidr-2  = var.tgw-route-cidr-2_hipaa_chcs_vpc_prod
  tgw-route-cidr-3  = var.tgw-route-cidr-3_hipaa_chcs_vpc_prod
  tgw-route-cidr-4  = var.tgw-route-cidr-4_hipaa_chcs_vpc_prod
  tgw-route-cidr-5  = var.tgw-route-cidr-5_hipaa_chcs_vpc_prod
  tgw-route-cidr-6  = var.tgw-route-cidr-6_hipaa_chcs_vpc_prod
  tgw-route-cidr-7  = var.tgw-route-cidr-7_hipaa_chcs_vpc_prod
  tgw-route-cidr-8  = var.tgw-route-cidr-8_hipaa_chcs_vpc_prod
  
  transit_gateway_id                               = module.tgw.ec2_transit_gateway_id
  providers = {
    aws.dst = aws.chcs-prod
  }
}


##########################################################################################
# NON-PROD ACCOUNT VPC
#########################################################################################
module "PCI-CHCS-VPC-NON-PROD" {
  source  = "./../modules/vpc-module"
  name = var.name_pci_chcs_vpc_non_prod
  cidr = var.cidr_pci_chcs_vpc_non_prod
  azs             = var.azs_pci_chcs_vpc_non_prod
  public_subnets  = var.public_subnets_pci_chcs_vpc_non_prod
  private_subnets = var.private_subnets_pci_chcs_vpc_non_prod
  private_dedicated_network_acl = true
  public_dedicated_network_acl = true

  tgw-route-cidr-1  = var.tgw-route-cidr-1_pci_chcs_vpc_non_prod
  tgw-route-cidr-2  = var.tgw-route-cidr-2_pci_chcs_vpc_non_prod
  tgw-route-cidr-3  = var.tgw-route-cidr-3_pci_chcs_vpc_non_prod
  tgw-route-cidr-4  = var.tgw-route-cidr-4_pci_chcs_vpc_non_prod
  tgw-route-cidr-5  = var.tgw-route-cidr-5_pci_chcs_vpc_non_prod
  tgw-route-cidr-6  = var.tgw-route-cidr-6_pci_chcs_vpc_non_prod
  tgw-route-cidr-7  = var.tgw-route-cidr-7_pci_chcs_vpc_non_prod
  tgw-route-cidr-8  = var.tgw-route-cidr-8_pci_chcs_vpc_non_prod
  
  transit_gateway_id                             = module.tgw.ec2_transit_gateway_id
   providers = {
    aws.dst = aws.chcs-non-prod
  }
}

module "HIPAA-CHCS-VPC-NON-PROD" {
  source  = "./../modules/vpc-module"
  name = var.name_hipaa_chcs_vpc_non_prod
  cidr = var.cidr_hipaa_chcs_vpc_non_prod
  azs             = var.azs_hipaa_chcs_vpc_non_prod
  public_subnets  = var.public_subnets_hipaa_chcs_vpc_non_prod
  private_subnets = var.private_subnets_hipaa_chcs_vpc_non_prod
  private_dedicated_network_acl = true
  public_dedicated_network_acl = true

  tgw-route-cidr-1   = var.tgw-route-cidr-1_hipaa_chcs_vpc_non_prod
  tgw-route-cidr-2   = var.tgw-route-cidr-2_hipaa_chcs_vpc_non_prod
  tgw-route-cidr-3   = var.tgw-route-cidr-3_hipaa_chcs_vpc_non_prod
  tgw-route-cidr-4   = var.tgw-route-cidr-4_hipaa_chcs_vpc_non_prod
  tgw-route-cidr-5   = var.tgw-route-cidr-5_hipaa_chcs_vpc_non_prod
  tgw-route-cidr-6   = var.tgw-route-cidr-6_hipaa_chcs_vpc_non_prod
  tgw-route-cidr-7   = var.tgw-route-cidr-7_hipaa_chcs_vpc_non_prod
  tgw-route-cidr-8   = var.tgw-route-cidr-8_hipaa_chcs_vpc_non_prod
 
  transit_gateway_id                               = module.tgw.ec2_transit_gateway_id
   providers = {
    aws.dst = aws.chcs-non-prod
  }
}

module "DEV-QA-UAT-CHCS-VPC-NON-PROD" {
  source  = "./../modules/vpc-module"
  name = var.name_dev_qa_uat_chcs_vpc_non_prod
  cidr = var.cidr_dev_qa_uat_chcs_vpc_non_prod
  azs             = var.azs_dev_qa_uat_chcs_vpc_non_prod
  public_subnets  = var.public_subnets_dev_qa_uat_chcs_vpc_non_prod
  private_subnets = var.private_subnets_dev_qa_uat_chcs_vpc_non_prod
  private_dedicated_network_acl = true
  public_dedicated_network_acl = true

  tgw-route-cidr-1  = var.tgw-route-cidr-1_dev_qa_uat_chcs_vpc_non_prod
  tgw-route-cidr-2  = var.tgw-route-cidr-2_dev_qa_uat_chcs_vpc_non_prod
  tgw-route-cidr-3  = var.tgw-route-cidr-3_dev_qa_uat_chcs_vpc_non_prod
  tgw-route-cidr-4  = var.tgw-route-cidr-4_dev_qa_uat_chcs_vpc_non_prod
  tgw-route-cidr-5  = var.tgw-route-cidr-5_dev_qa_uat_chcs_vpc_non_prod
  tgw-route-cidr-6  = var.tgw-route-cidr-6_dev_qa_uat_chcs_vpc_non_prod
  tgw-route-cidr-7  = var.tgw-route-cidr-7_dev_qa_uat_chcs_vpc_non_prod
  tgw-route-cidr-8  = var.tgw-route-cidr-8_dev_qa_uat_chcs_vpc_non_prod
 
  transit_gateway_id                               = module.tgw.ec2_transit_gateway_id
  providers = {
    aws.dst = aws.chcs-non-prod
  }
}

####################################################################
# PCI CHCS ACCOUNT
####################################################################

module "PCI-CHCS-VPC-PCI" {
  source  = "./../modules/vpc-module"
  name = var.name_pci_chcs_vpc_pci
  cidr = var.cidr_pci_chcs_vpc_pci
  azs             = var.azs_pci_chcs_vpc_pci
  private_subnets = var.private_subnets_pci_chcs_vpc_pci
  public_subnets  = var.public_subnets_pci_chcs_vpc_pci
  private_dedicated_network_acl = true
  public_dedicated_network_acl = true

  tgw-route-cidr-1  = var.tgw-route-cidr-1_pci_chcs_vpc_pci
  tgw-route-cidr-2  = var.tgw-route-cidr-2_pci_chcs_vpc_pci
  tgw-route-cidr-3  = var.tgw-route-cidr-3_pci_chcs_vpc_pci
  tgw-route-cidr-4  = var.tgw-route-cidr-4_pci_chcs_vpc_pci
  tgw-route-cidr-5  = var.tgw-route-cidr-5_pci_chcs_vpc_pci
  tgw-route-cidr-6  = var.tgw-route-cidr-6_pci_chcs_vpc_pci
  tgw-route-cidr-7  = var.tgw-route-cidr-7_pci_chcs_vpc_pci
  tgw-route-cidr-8  = var.tgw-route-cidr-8_pci_chcs_vpc_pci

  transit_gateway_id                             = module.tgw.ec2_transit_gateway_id
  providers = {
    aws.dst = aws.chcs-pci
  }
}

####################################################################
# SHARED SERVICE ACCOUNT
####################################################################

module "SHARED-SERVICE-CHCS-VPC" {
  source  = "./../modules/vpc-module"
  name = var.name_shared_service_chcs_vpc
  cidr = var.cidr_shared_service_chcs_vpc
  azs             = var.azs_shared_service_chcs_vpc
  public_subnets = var.public_subnets_shared_service_chcs_vpc
  private_subnets  = var.private_subnets_shared_service_chcs_vpc
  private_dedicated_network_acl = true
  public_dedicated_network_acl = true

  tgw-route-cidr-1  = var.tgw-route-cidr-1_shared_service_chcs_vpc
  tgw-route-cidr-2  = var.tgw-route-cidr-2_shared_service_chcs_vpc
  tgw-route-cidr-3  = var.tgw-route-cidr-3_shared_service_chcs_vpc
  tgw-route-cidr-4  = var.tgw-route-cidr-4_shared_service_chcs_vpc
  tgw-route-cidr-5  = var.tgw-route-cidr-5_shared_service_chcs_vpc
  tgw-route-cidr-6  = var.tgw-route-cidr-6_shared_service_chcs_vpc
  tgw-route-cidr-7  = var.tgw-route-cidr-7_shared_service_chcs_vpc
  tgw-route-cidr-8  = var.tgw-route-cidr-8_shared_service_chcs_vpc

  transit_gateway_id                             = module.tgw.ec2_transit_gateway_id
  providers = {
    aws.dst = aws.chcs-shared
  }
}

module "BASTION-VPC-SHARED-SERVICE" {
  source  = "./../modules/vpc-module"
  name = var.name_bastion_vpc_shared_service
  cidr = var.cidr_bastion_vpc_shared_service
  azs             = var.azs_bastion_vpc_shared_service
  public_subnets  = var.public_subnets_bastion_vpc_shared_service
  public_dedicated_network_acl = true

  tgw-route-cidr-1  = var.tgw-route-cidr-1_bastion_vpc_shared_service
  tgw-route-cidr-2  = var.tgw-route-cidr-2_bastion_vpc_shared_service
  tgw-route-cidr-3  = var.tgw-route-cidr-3_bastion_vpc_shared_service
  tgw-route-cidr-4  = var.tgw-route-cidr-4_bastion_vpc_shared_service
  tgw-route-cidr-5  = var.tgw-route-cidr-5_bastion_vpc_shared_service
  tgw-route-cidr-6  = var.tgw-route-cidr-6_bastion_vpc_shared_service
  tgw-route-cidr-7  = var.tgw-route-cidr-7_bastion_vpc_shared_service
  tgw-route-cidr-8  = var.tgw-route-cidr-8_bastion_vpc_shared_service

  transit_gateway_id                             = module.tgw.ec2_transit_gateway_id
  providers = {
    aws.dst = aws.chcs-shared
  }
}

/*
##############################################################
# SG FOR TRANSIT ACCOUNT
##############################################################

module "sg-tgw-transit" {
  source = "./../modules/aws-sg-tgw"
  security_group_name = "TGW-sg-transit"
  vpc_id = module.INSPECTION-VPC-TRANSIT-PROD.vpc_id

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
    aws.dst = aws.chcs-transit
  }
}


##############################################################
# SG FOR PROD ACCOUNT
##############################################################

module "sg-tgw" {
  source = "./../modules/aws-sg-tgw"
  security_group_name = "TGW-sg"
  vpc_id = module.HIPAA-CHCS-VPC-PROD.vpc_id

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
    aws.dst = aws.chcs-prod
  }
}

#################################################################
# SG FOR NON-PROD ACCOUNT
#################################################################

module "sg-tgw-1" {
  source = "./../modules/aws-sg-tgw"
  security_group_name = "TGW-sg"
  vpc_id = module.PCI-CHCS-VPC-NON-PROD.vpc_id

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
    aws.dst = aws.chcs-non-prod
  }
}

#################################################################
# SG FOR PCI ACCOUNT
#################################################################

module "sg-tgw-pci" {
  source = "./../modules/aws-sg-tgw"
  security_group_name = "TGW-sg-pci"
  vpc_id = module.PCI-CHCS-VPC-PCI.vpc_id

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
    aws.dst = aws.chcs-pci
  }
}


#################################################################
# SG FOR SHARED ACCOUNT
#################################################################

module "sg-tgw-shared" {
  source = "./../modules/aws-sg-tgw"
  security_group_name = "TGW-sg-shared"
  vpc_id = module.SHARED-SERVICE-CHCS-VPC.vpc_id

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
    aws.dst = aws.chcs-shared
  }
}

#################################################################
# EC2 INSTANCE IN TRANSIT ACCOUNT
##############################################################

module "ec2-transit-public" {
  source                        = "./../modules/aws-ec2"
  key_name                      = "transit-public"
  public_key                    = file("./key-pub.pub")
  instance_count                = 1
  ami                           = "ami-0dc2d3e4c0f9ebd18"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "true"
   root_volume_size              = 8
  subnet_ids                    = module.INSPECTION-VPC-TRANSIT-PROD.public_subnets
  vpc_security_group_ids        = [module.sg-tgw-transit.aws_security_group]
  #iam_instance_profile          = module.s3-role-chcs-prod.aws_iam_s3_role
  ec2_tags = "HIPAA-VPC-PROD-EC2-VM1"
  providers = {
    aws.dst = aws.chcs-transit
  }
}

module "ec2-transit-private" {
  source                        = "./../modules/aws-ec2"
  key_name                      = "transit-private"
  public_key                    = file("./key-pub.pub")
  instance_count                = 1
  ami                           = "ami-0dc2d3e4c0f9ebd18"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "true"
   root_volume_size              = 8
  subnet_ids                    = module.INSPECTION-VPC-TRANSIT-PROD.private_subnets
  vpc_security_group_ids        = [module.sg-tgw-transit.aws_security_group]
  #iam_instance_profile          = module.s3-role-chcs-prod.aws_iam_s3_role
  ec2_tags = "HIPAA-VPC-PROD-EC2-VM1"
  providers = {
    aws.dst = aws.chcs-transit
  }
}

#################################################################
# EC2 INSTANCE IN PROD ACCOUNT
##############################################################

module "ec2-prod-public" {
  source                        = "./../modules/aws-ec2"
  key_name                      = "transit-gateway-mark-1"
  public_key                    = file("./key-pub.pub")
  instance_count                = 1
  ami                           = "ami-0dc2d3e4c0f9ebd18"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "true"
   root_volume_size              = 8
  subnet_ids                    = module.HIPAA-CHCS-VPC-PROD.public_subnets
  vpc_security_group_ids        = [module.sg-tgw.aws_security_group]
  iam_instance_profile          = module.s3-role-chcs-prod.aws_iam_s3_role
  ec2_tags = "HIPAA-VPC-PROD-EC2-VM1"
  providers = {
    aws.dst = aws.chcs-prod
  }
  
}

module "ec2-prod-private" {
  source                        = "./../modules/aws-ec2"
  key_name                      = "transit-gateway-mark"
  public_key                    = file("./key-prv.pub")
  instance_count                = 1
  ami                           = "ami-0dc2d3e4c0f9ebd18"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "false"
  root_volume_size              = 8
  subnet_ids                    = module.HIPAA-CHCS-VPC-PROD.private_subnets
  vpc_security_group_ids        = [module.sg-tgw.aws_security_group]
  iam_instance_profile          = module.s3-role-chcs-prod.aws_iam_s3_role
  ec2_tags = "HIPAA-VPC-PROD-EC2-VM2"
  providers = {
    aws.dst = aws.chcs-prod
  }
}

#################################################################
# EC2 INSTANCE IN NON PROD ACCOUNT
##############################################################

module "ec2-non-prod-public" {
  source                        = "./../modules/aws-ec2"
  key_name                      = "transit-gateway-chris-1"
  public_key                    = file("./key-pub.pub")
  instance_count                = 1
  ami                           = "ami-0dc2d3e4c0f9ebd18"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "true"
  root_volume_size              = 8
  subnet_ids                    = module.PCI-CHCS-VPC-NON-PROD.public_subnets
  vpc_security_group_ids        = [module.sg-tgw-1.aws_security_group]
  iam_instance_profile          = module.s3-role-chcs-non-prod.aws_iam_s3_role
  ec2_tags = "NONPROD-EC2-VM-PUBLIC"
  providers = {
    aws.dst = aws.chcs-non-prod
  }
}
     
module "ec2-non-prod-private" {
  source                        = "./../modules/aws-ec2"
  key_name                      = "transit-gateway-chris"
  public_key                    = file("./key-prv.pub")
  instance_count                = 1
  ami                           = "ami-0dc2d3e4c0f9ebd18"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "false"
  root_volume_size              = 8
  subnet_ids                    = module.PCI-CHCS-VPC-NON-PROD.private_subnets
  vpc_security_group_ids        = [module.sg-tgw-1.aws_security_group]
  iam_instance_profile          = module.s3-role-chcs-non-prod.aws_iam_s3_role
  ec2_tags = "NONPROD-EC2-VM-PRIVATE"
  providers = {
    aws.dst = aws.chcs-non-prod
  }
}

#################################################################
# EC2 INSTANCE IN PCI ACCOUNT
##############################################################

module "ec2-pci-public" {
  source                        = "./../modules/aws-ec2"
  key_name                      = "pci-public"
  public_key                    = file("./key-pub.pub")
  instance_count                = 1
  ami                           = "ami-0dc2d3e4c0f9ebd18"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "true"
   root_volume_size              = 8
  subnet_ids                    = module.PCI-CHCS-VPC-PCI.public_subnets
  vpc_security_group_ids        = [module.sg-tgw-pci.aws_security_group]
  #iam_instance_profile          = module.s3-role-chcs-prod.aws_iam_s3_role
  ec2_tags = "PCI-CHCS-EC2-VM1"
  providers = {
    aws.dst = aws.chcs-pci
  }
}

module "ec2-pci-private" {
  source                        = "./../modules/aws-ec2"
  key_name                      = "pci-private"
  public_key                    = file("./key-pub.pub")
  instance_count                = 1
  ami                           = "ami-0dc2d3e4c0f9ebd18"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "true"
   root_volume_size              = 8
  subnet_ids                    = module.PCI-CHCS-VPC-PCI.private_subnets
  vpc_security_group_ids        = [module.sg-tgw-pci.aws_security_group]
  #iam_instance_profile          = module.s3-role-chcs-prod.aws_iam_s3_role
  ec2_tags = "PCI-CHCS-EC2-VM2"
  providers = {
    aws.dst = aws.chcs-pci
  }
}

#################################################################
# EC2 INSTANCE IN SHARED ACCOUNT
##############################################################

module "ec2-shared-public" {
  source                        = "./../modules/aws-ec2"
  key_name                      = "shared-public"
  public_key                    = file("./key-pub.pub")
  instance_count                = 1
  ami                           = "ami-0dc2d3e4c0f9ebd18"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "true"
   root_volume_size              = 8
  subnet_ids                    = module.SHARED-SERVICE-CHCS-VPC.public_subnets
  vpc_security_group_ids        = [module.sg-tgw-shared.aws_security_group]
  #iam_instance_profile          = module.s3-role-chcs-prod.aws_iam_s3_role
  ec2_tags = "SHARED-SERVICE-CHCS-EC2-VM1"
  providers = {
    aws.dst = aws.chcs-shared
  }
}

module "ec2-shared-private" {
  source                        = "./../modules/aws-ec2"
  key_name                      = "shared-private"
  public_key                    = file("./key-pub.pub")
  instance_count                = 1
  ami                           = "ami-0dc2d3e4c0f9ebd18"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "true"
   root_volume_size             = 8
  subnet_ids                    = module.SHARED-SERVICE-CHCS-VPC.private_subnets
  vpc_security_group_ids        = [module.sg-tgw-shared.aws_security_group]
  #iam_instance_profile         = module.s3-role-chcs-prod.aws_iam_s3_role
  ec2_tags = "PCI-CHCS-EC2-VM1"
  providers = {
    aws.dst = aws.chcs-shared
  }
}
*/

##############################################################################
# DR S3 ROLE FOR PROD ACCOUNT
###########################################################################

module "s3-role-chcs-prod" {
  source     ="./../modules/s3-role"
  iam_role_name  =  ["s3-role-prod"] 
  iam_policy_name =  ["iam-policy-prod"]
  iam_policy_attachment_name = ["iam-attachment-policy-prod"]
  iam_instance_profile_name = ["iam-instance-profile-prods"]
  providers = {
    aws = aws.chcs-prod
  }
}

##############################################################################
# DR S3 ROLE FOR NON-PROD ACCOUNT
###########################################################################

module "s3-role-chcs-non-prod" {
  source     ="./../modules/s3-role"
  
  iam_role_name  =  ["s3-role-prod"] 
  iam_policy_name =  ["iam-policy-prod"]
  iam_policy_attachment_name = ["iam-attachment-policy-prod"]
  iam_instance_profile_name = ["iam-instance-profile-prods"]
  providers = {
    aws = aws.chcs-non-prod
  }
}


#########################################################################
# DR VPC ENDPOINT FOR PROD ACCOUNT
#########################################################################

module "SHARED-CHCS-VPC-PROD-ENDPOINT" {
  source = "./../modules/vpc-endpoints"
  vpc_id = module.SHARED-CHCS-VPC-PROD.vpc_id
  vpc-gateway-endpoint = "S3-SHARED-CHCS-VPC-NON-PROD-ENDPOINT"
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
      route_table_ids     = module.SHARED-CHCS-VPC-PROD.private_route_table_ids
    }
  }
 providers = {
    aws = aws.chcs-prod
   }
}

module "HIPAA-CHCS-VPC-PROD-ENDPOINT" {
  source = "./../modules/vpc-endpoints"
  vpc_id = module.HIPAA-CHCS-VPC-PROD.vpc_id
  vpc-gateway-endpoint = "S3-HIPAA-CHCS-VPC-NON-PROD-ENDPOINT"
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
      route_table_ids     = module.HIPAA-CHCS-VPC-PROD.private_route_table_ids
    }
  }
 providers = {
    aws = aws.chcs-prod
   }
}


#########################################################################
# VPC ENDPOINT FOR NON-PROD ACCOUNT
#########################################################################

module "PCI-CHCS-VPC-NON-PROD-ENDPOINT" {
  source = "./../modules/vpc-endpoints"
  vpc_id = module.PCI-CHCS-VPC-NON-PROD.vpc_id
  vpc-gateway-endpoint = "S3-PCI-CHCS-VPC-NON-PROD-ENDPOINT"
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
      route_table_ids     = module.PCI-CHCS-VPC-NON-PROD.private_route_table_ids
    }
  }

 providers = {
    aws = aws.chcs-non-prod
   }
}

module "HIPAA-CHCS-VPC-NON-PROD-ENDPOINT" {
  source = "./../modules/vpc-endpoints"
  vpc_id = module.HIPAA-CHCS-VPC-NON-PROD.vpc_id
  vpc-gateway-endpoint = "S3-HIPAA-CHCS-VPC-NON-PROD-ENDPOINT"
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
      route_table_ids     = module.HIPAA-CHCS-VPC-NON-PROD.private_route_table_ids
    }
  }
 providers = {
    aws = aws.chcs-non-prod
   }
}

module "DEV-QA-UAT-CHCS-VPC-NON-PROD-ENDPOINT" {
  source = "./../modules/vpc-endpoints"
  vpc_id = module.DEV-QA-UAT-CHCS-VPC-NON-PROD.vpc_id
  vpc-gateway-endpoint = "S3-DEV-QA-UAT-CHCS-VPC-NON-PROD-ENDPOINT"
  gateway_vpc_endpoints = {
    "S3-DEV-QA-UAT-CHCS-VPC-NON-PROD-ENDPOINT" = {
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
      route_table_ids     = module.DEV-QA-UAT-CHCS-VPC-NON-PROD.private_route_table_ids
    }
  }
 providers = {
    aws = aws.chcs-non-prod
   }
}
