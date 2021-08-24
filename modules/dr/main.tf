provider "aws" {
  region = var.region
}

provider "aws" {
  alias                   = "chcs-shared-dr"
  region                  = var.region
  assume_role {
    role_arn = var.role_arn_shared_dr
  }
}

provider "aws" {
  alias                   = "chcs-transit-dr"
  region                  = var.region
  assume_role {
    role_arn = var.role_arn_transit_dr
  }
}
provider "aws" {
  region = var.region
  alias  = "chcs-prod-dr"
   assume_role {
     role_arn = var.role_arn_prod_dr
  }
}

provider "aws" {
  region = var.region
  alias  = "chcs-non-prod-dr"
   assume_role {
     role_arn = var.role_arn_non_prod_dr
  }
}

provider "aws" {
  region = var.region
  alias  = "chcs-pci-dr"
   assume_role {
     role_arn = var.role_arn_pci_dr
  }
}

##########################################################################################
# TANSIT GATEWAY DR IN TRANSIT ACCOUNT
#########################################################################################

module "tgw" {
  source = "terraform-aws-modules/transit-gateway/aws"
  providers = {
    aws = aws.chcs-transit-dr
  }
  name            = var.name_transit_tgw
  description     = var.description_transit_tgw
  amazon_side_asn = var.amazon_side_asn_transit
  enable_auto_accept_shared_attachments = var.enable_auto_accept_shared_attachments_transit  # When "true" there is no need for RAM resources if using multiple AWS accounts
  vpc_attachments = {
    INSPECTION-VPC-TRANSIT-DR = {
      vpc_id     = module.INSPECTION-VPC-TRANSIT-DR.vpc_id
      subnet_ids = module.INSPECTION-VPC-TRANSIT-DR.private_subnets_0
    }
  }
  ram_allow_external_principals = var.ram_allow_external_principals
#  ram_principals                = [682258877194, 551294210778, 530420366225, 279108474419]
  ram_principals                = var.ram_principals_transit

  tags = {
    Purpose = var.tags_transit_purpose
  }
}

##########################################################################################
# TRANSIT GATEWAY DR IN PROD ACCOUNT
#########################################################################################

module "tgw_peer_prod_dr" {
  source = "terraform-aws-modules/transit-gateway/aws"
  providers = {
    aws = aws.chcs-prod-dr
  }
  name            = var.name_prod_dr_tgwpeer
  description     = var.description_prod_dr_tgw
  amazon_side_asn = var.amazon_side_asn_transit
  share_tgw                             = var.share_tgw
  create_tgw                            = var.create_tgw
  ram_resource_share_arn                = module.tgw.ram_resource_share_id
  enable_auto_accept_shared_attachments = var.enable_auto_accept_shared_attachments_transit # When "true" there is no need for RAM resources if using multiple AWS accounts
  vpc_attachments = {
    SHARED-CHCS-VPC-PROD-DR = {
      tgw_id                                          = module.tgw.ec2_transit_gateway_id
      vpc_id                                          = module.SHARED-CHCS-VPC-PROD-DR.vpc_id
      subnet_ids                                      = module.SHARED-CHCS-VPC-PROD-DR.public_subnets_0
      dns_support                                     = var.dns_support
    },
    HIPAA-CHCS-VPC-PROD-DR = {
      tgw_id                                          = module.tgw.ec2_transit_gateway_id
      vpc_id                                          = module.HIPAA-CHCS-VPC-PROD-DR.vpc_id
      subnet_ids                                      = module.HIPAA-CHCS-VPC-PROD-DR.public_subnets_0
      dns_support                                     = var.dns_support
    }
  }
  ram_allow_external_principals = var.ram_allow_external_principals

  ram_principals                = var.ram_principals_prod_dr
  tags = {
    Purpose = var.tags_prod_dr_purpose
  }
}

##########################################################################################
# TANSIT GATEWAY DR IN NON-PROD ACCOUNT
#########################################################################################

module "tgw_peer_nonprod_dr" {
  source = "terraform-aws-modules/transit-gateway/aws"
  providers = {
    aws = aws.chcs-non-prod-dr
  }
  name            = var.name_nonprod_dr_tgwpeer
  description     = var.description_nonprod_dr_tgw
  amazon_side_asn = var.amazon_side_asn_transit
  share_tgw                             = var.share_tgw
  create_tgw                            = var.create_tgw
  ram_resource_share_arn                = module.tgw.ram_resource_share_id
  enable_auto_accept_shared_attachments = var.enable_auto_accept_shared_attachments_transit # When "true" there is no need for RAM resources if using multiple AWS accounts
  vpc_attachments = {
    PCI-CHCS-VPC-NON-PROD-DR = {
      tgw_id                                          = module.tgw.ec2_transit_gateway_id
      vpc_id                                          = module.PCI-CHCS-VPC-NON-PROD-DR.vpc_id
      subnet_ids                                      = module.PCI-CHCS-VPC-NON-PROD-DR.public_subnets_0
      dns_support                                     = var.dns_support
    },
    HIPAA-CHCS-VPC-NON-PROD-DR = {
      tgw_id                                          = module.tgw.ec2_transit_gateway_id
      vpc_id                                          = module.HIPAA-CHCS-VPC-NON-PROD-DR.vpc_id
      subnet_ids                                      = module.HIPAA-CHCS-VPC-NON-PROD-DR.public_subnets_0
      dns_support                                     = var.dns_support
    },
    DEV-QA-UAT-CHCS-VPC-NON-PROD-DR = {
      tgw_id                                          = module.tgw.ec2_transit_gateway_id
      vpc_id                                          = module.DEV-QA-UAT-CHCS-VPC-NON-PROD-DR.vpc_id
      subnet_ids                                      = module.DEV-QA-UAT-CHCS-VPC-NON-PROD-DR.public_subnets_0
      dns_support                                     = var.dns_support
    }
  }
  ram_allow_external_principals = var.ram_allow_external_principals
  ram_principals                = var.ram_principals_nonprod_dr
  tags = {
    Purpose = var.tags_nonprod_dr_purpose
  }
}

###################################################################################
#######
# TANSIT GATEWAY DR IN PCI ACCOUNT DR
###################################################################################
######

module "tgw_peer_pci" {
  source = "terraform-aws-modules/transit-gateway/aws"
  providers = {
    aws = aws.chcs-pci-dr
  }

  name            = var.name_pci_dr_tgwpeer
  description     = var.description_pci_dr_tgw
  amazon_side_asn = var.amazon_side_asn_transit
  share_tgw                             = var.share_tgw
  create_tgw                            = var.create_tgw
  ram_resource_share_arn                = module.tgw.ram_resource_share_id
  enable_auto_accept_shared_attachments = var.enable_auto_accept_shared_attachments_transit
  vpc_attachments = {
    PCI-CHCS-VPC-PCI-DR = {
      tgw_id                                          = module.tgw.ec2_transit_gateway_id
      vpc_id                                          = module.PCI-CHCS-VPC-PCI-DR.vpc_id
      subnet_ids                                      = module.PCI-CHCS-VPC-PCI-DR.public_subnets_0
      dns_support                                     = var.dns_support
    }
  }
  
  ram_allow_external_principals = var.ram_allow_external_principals

  ram_principals                = var.ram_principals_pci_dr
  tags = {
    Purpose = var.tags_pci_dr_purpose
  }
}

#############################################################################
# SHARED SERVICE ACCOUNT
#############################################################################

module "tgw_peer_shared_service_dr" {
  source = "terraform-aws-modules/transit-gateway/aws"
  providers = {
    aws = aws.chcs-shared-dr
  }
  name            = var.name_shared_dr_tgwpeer
  description     = var.description_shared_dr_tgw
  amazon_side_asn = var.amazon_side_asn_transit
  share_tgw                             = var.share_tgw
  create_tgw                            = var.create_tgw
  ram_resource_share_arn                = module.tgw.ram_resource_share_id
  enable_auto_accept_shared_attachments = var.enable_auto_accept_shared_attachments_transit # When "true" there is no need for RAM resources if using multiple AWS accounts
  vpc_attachments = {
    SHARED-SERVICE-CHCS-VPC-DR = {
      tgw_id                                          = module.tgw.ec2_transit_gateway_id
      vpc_id                                          = module.SHARED-SERVICE-CHCS-VPC-DR.vpc_id
      subnet_ids                                      = module.SHARED-SERVICE-CHCS-VPC-DR.public_subnets_0
      dns_support                                     = var.dns_support
    },
    BASTION-VPC-SHARED-SERVICE-DR = {
      tgw_id                                          = module.tgw.ec2_transit_gateway_id
      vpc_id                                          = module.BASTION-VPC-SHARED-SERVICE-DR.vpc_id
      subnet_ids                                      = module.BASTION-VPC-SHARED-SERVICE-DR.public_subnets_0
      dns_support                                     = var.dns_support
    }
  }

  ram_allow_external_principals = var.ram_allow_external_principals
  ram_principals                = var.ram_principals_shared_dr
  tags = {
    Purpose = var.tags_shared_dr_purpose
  }
}

##########################################################################################
# DR VPC FOR TRANSIT ACCOUNT
#########################################################################################

module "INSPECTION-VPC-TRANSIT-DR" {
  source  = "./../modules/vpc-module-single"
  name = var.name_inspection_vpc_transit_dr
  cidr = var.cidr_inspection_vpc_transit_dr
  azs             = var.azs_inspection_vpc_transit_dr
  private_subnets = var.private_subnets_inspection_vpc_transit_dr
  public_subnets  = var.public_subnets_inspection_vpc_transit_dr
  private_dedicated_network_acl = var.private_dedicated_network_acl
  public_dedicated_network_acl = var.public_dedicated_network_acl
/*  
  private_inbound_acl_rules = var.private_network_acl_ingress
  private_outbound_acl_rules = var.private_network_acl_egress
  public_inbound_acl_rules = var.public_network_acl_ingress
  public_outbound_acl_rules = var.public_network_acl_egress

  private_inbound_acl_rules       = concat(local.network_acls["default_inbound"], local.network_acls["private_inbound"])
  private_outbound_acl_rules      = concat(local.network_acls["default_outbound"], local.network_acls["private_outbound"])
  public_inbound_acl_rules       = concat(local.network_acls["default_inbound"], local.network_acls["public_inbound"])
  public_outbound_acl_rules      = concat(local.network_acls["default_outbound"], local.network_acls["public_outbound"])
*/
  tgw-route-cidr-1        = var.tgw-route-cidr-1_inspection_vpc_transit_dr
  tgw-route-cidr-2        = var.tgw-route-cidr-2_inspection_vpc_transit_dr    
  tgw-route-cidr-3        = var.tgw-route-cidr-3_inspection_vpc_transit_dr
  tgw-route-cidr-4        = var.tgw-route-cidr-4_inspection_vpc_transit_dr
  tgw-route-cidr-5        = var.tgw-route-cidr-5_inspection_vpc_transit_dr
  tgw-route-cidr-6        = var.tgw-route-cidr-6_inspection_vpc_transit_dr
  tgw-route-cidr-7        = var.tgw-route-cidr-7_inspection_vpc_transit_dr      
  tgw-route-cidr-8        = var.tgw-route-cidr-8_inspection_vpc_transit_dr
  transit_gateway_id      = module.tgw.ec2_transit_gateway_id
  providers = {
    aws.dst = aws.chcs-transit-dr
  }
}

##########################################################################################
# DR VPC FOR PROD ACCOUNT
#########################################################################################

module "SHARED-CHCS-VPC-PROD-DR" {
  source  = "./../modules/vpc-module"
  name = var.name_shared_chcs_vpc_prod_dr
  cidr = var.cidr_shared_chcs_vpc_prod_dr
  azs             = var.azs_shared_chcs_vpc_prod_dr
  public_subnets  = var.public_subnets_shared_chcs_vpc_prod_dr
  private_subnets = var.private_subnets_shared_chcs_vpc_prod_dr
  private_dedicated_network_acl = var.private_dedicated_network_acl
  public_dedicated_network_acl = var.public_dedicated_network_acl
  
  tgw-route-cidr-1         = var.tgw-route-cidr-1_shared_chcs_vpc_prod_dr
  tgw-route-cidr-2         = var.tgw-route-cidr-2_shared_chcs_vpc_prod_dr
  tgw-route-cidr-3         = var.tgw-route-cidr-3_shared_chcs_vpc_prod_dr
  tgw-route-cidr-4         = var.tgw-route-cidr-4_shared_chcs_vpc_prod_dr
  tgw-route-cidr-5         = var.tgw-route-cidr-5_shared_chcs_vpc_prod_dr
  tgw-route-cidr-6         = var.tgw-route-cidr-6_shared_chcs_vpc_prod_dr
  tgw-route-cidr-7         = var.tgw-route-cidr-7_shared_chcs_vpc_prod_dr       
  tgw-route-cidr-8         = var.tgw-route-cidr-8_shared_chcs_vpc_prod_dr
  transit_gateway_id       = module.tgw.ec2_transit_gateway_id
  providers = {
    aws.dst = aws.chcs-prod-dr
  }
}

module "HIPAA-CHCS-VPC-PROD-DR" {
  source  = "./../modules/vpc-module"
  name = var.name_hipaa_chcs_vpc_prod_dr
  cidr = var.cidr_hipaa_chcs_vpc_prod_dr
  azs             = var.azs_hipaa_chcs_vpc_prod_dr
  public_subnets  = var.public_subnets_hipaa_chcs_vpc_prod_dr
  private_subnets = var.private_subnets_hipaa_chcs_vpc_prod_dr
  private_dedicated_network_acl = var.private_dedicated_network_acl
  public_dedicated_network_acl = var.public_dedicated_network_acl

  tgw-route-cidr-1      = var.tgw-route-cidr-1_hipaa_chcs_vpc_prod_dr 
  tgw-route-cidr-2      = var.tgw-route-cidr-2_hipaa_chcs_vpc_prod_dr
  tgw-route-cidr-3      = var.tgw-route-cidr-3_hipaa_chcs_vpc_prod_dr                      
  tgw-route-cidr-4      = var.tgw-route-cidr-4_hipaa_chcs_vpc_prod_dr                 
  tgw-route-cidr-5      = var.tgw-route-cidr-5_hipaa_chcs_vpc_prod_dr                     
  tgw-route-cidr-6      = var.tgw-route-cidr-6_hipaa_chcs_vpc_prod_dr                     
  tgw-route-cidr-7      = var.tgw-route-cidr-7_hipaa_chcs_vpc_prod_dr                   
  tgw-route-cidr-8      = var.tgw-route-cidr-8_hipaa_chcs_vpc_prod_dr

  transit_gateway_id                             = module.tgw.ec2_transit_gateway_id
  providers = {
    aws.dst = aws.chcs-prod-dr
  }
}

##########################################################################################
# DR VPC  FOR NON-PROD ACCOUNT
#########################################################################################

module "PCI-CHCS-VPC-NON-PROD-DR" {
  source  = "./../modules/vpc-module"
  name = var.name_pci_chcs_vpc_non_prod_dr
  cidr = var.cidr_pci_chcs_vpc_non_prod_dr
  azs             = var.azs_pci_chcs_vpc_non_prod_dr
  public_subnets = var.public_subnets_pci_chcs_vpc_non_prod_dr
  private_subnets = var.private_subnets_pci_chcs_vpc_non_prod_dr
  private_dedicated_network_acl = var.private_dedicated_network_acl
  public_dedicated_network_acl = var.public_dedicated_network_acl

  tgw-route-cidr-1    = var.tgw-route-cidr-1_pci_chcs_vpc_non_prod_dr
  tgw-route-cidr-2    = var.tgw-route-cidr-2_pci_chcs_vpc_non_prod_dr
  tgw-route-cidr-3    = var.tgw-route-cidr-3_pci_chcs_vpc_non_prod_dr
  tgw-route-cidr-4    = var.tgw-route-cidr-4_pci_chcs_vpc_non_prod_dr
  tgw-route-cidr-5    = var.tgw-route-cidr-5_pci_chcs_vpc_non_prod_dr
  tgw-route-cidr-6    = var.tgw-route-cidr-6_pci_chcs_vpc_non_prod_dr
  tgw-route-cidr-7    = var.tgw-route-cidr-7_pci_chcs_vpc_non_prod_dr
  tgw-route-cidr-8    = var.tgw-route-cidr-8_pci_chcs_vpc_non_prod_dr
 
  transit_gateway_id                             = module.tgw.ec2_transit_gateway_id
  providers = {

    aws.dst = aws.chcs-non-prod-dr
  }
}


module "HIPAA-CHCS-VPC-NON-PROD-DR" {
  source  = "./../modules/vpc-module"
  name = var.name_hipaa_chcs_vpc_non_prod_dr
  cidr = var.cidr_hipaa_chcs_vpc_non_prod_dr
  azs             = var.azs_hipaa_chcs_vpc_non_prod_dr
  public_subnets = var.public_subnets_hipaa_chcs_vpc_non_prod_dr
  private_subnets = var.private_subnets_hipaa_chcs_vpc_non_prod_dr
  private_dedicated_network_acl = var.private_dedicated_network_acl
  public_dedicated_network_acl = var.public_dedicated_network_acl
  
  tgw-route-cidr-1    = var.tgw-route-cidr-1_hipaa_chcs_vpc_non_prod_dr
  tgw-route-cidr-2    = var.tgw-route-cidr-2_hipaa_chcs_vpc_non_prod_dr
  tgw-route-cidr-3    = var.tgw-route-cidr-3_hipaa_chcs_vpc_non_prod_dr
  tgw-route-cidr-4    = var.tgw-route-cidr-4_hipaa_chcs_vpc_non_prod_dr
  tgw-route-cidr-5    = var.tgw-route-cidr-5_hipaa_chcs_vpc_non_prod_dr
  tgw-route-cidr-6    = var.tgw-route-cidr-6_hipaa_chcs_vpc_non_prod_dr
  tgw-route-cidr-7    = var.tgw-route-cidr-7_hipaa_chcs_vpc_non_prod_dr
  tgw-route-cidr-8    = var.tgw-route-cidr-8_hipaa_chcs_vpc_non_prod_dr
  
  transit_gateway_id                             = module.tgw.ec2_transit_gateway_id
  providers = {
    aws.dst = aws.chcs-non-prod-dr
  }
}


module "DEV-QA-UAT-CHCS-VPC-NON-PROD-DR" {
  source  = "./../modules/vpc-module"
  name = var.name_dev_qa_uat_chcs_vpc_non_prod_dr
  cidr = var.cidr_dev_qa_uat_chcs_vpc_non_prod_dr
  azs             = var.azs_dev_qa_uat_chcs_vpc_non_prod_dr
  public_subnets = var.public_subnets_dev_qa_uat_chcs_vpc_non_prod_dr
  private_subnets = var.private_subnets_dev_qa_uat_chcs_vpc_non_prod_dr
  private_dedicated_network_acl = var.private_dedicated_network_acl
  public_dedicated_network_acl = var.public_dedicated_network_acl
  
  tgw-route-cidr-1    = var.tgw-route-cidr-1_dev_qa_uat_chcs_vpc_non_prod_dr
  tgw-route-cidr-2    = var.tgw-route-cidr-2_dev_qa_uat_chcs_vpc_non_prod_dr
  tgw-route-cidr-3    = var.tgw-route-cidr-3_dev_qa_uat_chcs_vpc_non_prod_dr
  tgw-route-cidr-4    = var.tgw-route-cidr-4_dev_qa_uat_chcs_vpc_non_prod_dr
  tgw-route-cidr-5    = var.tgw-route-cidr-5_dev_qa_uat_chcs_vpc_non_prod_dr
  tgw-route-cidr-6    = var.tgw-route-cidr-6_dev_qa_uat_chcs_vpc_non_prod_dr
  tgw-route-cidr-7    = var.tgw-route-cidr-7_dev_qa_uat_chcs_vpc_non_prod_dr
  tgw-route-cidr-8    = var.tgw-route-cidr-8_dev_qa_uat_chcs_vpc_non_prod_dr

  transit_gateway_id                             = module.tgw.ec2_transit_gateway_id
  providers = {
    aws.dst = aws.chcs-non-prod-dr
  }
}

################################################################
# PCI Account DR
################################################################

module "PCI-CHCS-VPC-PCI-DR" {
  source  = "./../modules/vpc-module"
  name = var.name_pci_chcs_vpc_pci_dr
  cidr = var.cidr_pci_chcs_vpc_pci_dr
  azs             = var.azs_pci_chcs_vpc_pci_dr
  public_subnets = var.public_subnets_pci_chcs_vpc_pci_dr
  private_subnets = var.private_subnets_pci_chcs_vpc_pci_dr
  private_dedicated_network_acl = var.private_dedicated_network_acl
  public_dedicated_network_acl = var.public_dedicated_network_acl

  tgw-route-cidr-1  = var.tgw-route-cidr-1_pci_chcs_vpc_pci_dr
  tgw-route-cidr-2  = var.tgw-route-cidr-2_pci_chcs_vpc_pci_dr
  tgw-route-cidr-3  = var.tgw-route-cidr-3_pci_chcs_vpc_pci_dr
  tgw-route-cidr-4  = var.tgw-route-cidr-4_pci_chcs_vpc_pci_dr
  tgw-route-cidr-5  = var.tgw-route-cidr-5_pci_chcs_vpc_pci_dr
  tgw-route-cidr-6  = var.tgw-route-cidr-6_pci_chcs_vpc_pci_dr
  tgw-route-cidr-7  = var.tgw-route-cidr-7_pci_chcs_vpc_pci_dr
  tgw-route-cidr-8  = var.tgw-route-cidr-8_pci_chcs_vpc_pci_dr

  transit_gateway_id                             = module.tgw.ec2_transit_gateway_id
  providers = {
    aws.dst = aws.chcs-pci-dr
  }
}
####################################################################
# SHARED SERVICE ACCOUNT
####################################################################

module "SHARED-SERVICE-CHCS-VPC-DR" {
  source  = "./../modules/vpc-module"
  name = var.name_shared_service_chcs_vpc_dr
  cidr = var.cidr_shared_service_chcs_vpc_dr
  azs             = var.azs_shared_service_chcs_vpc_dr
  public_subnets = var.public_subnets_shared_service_chcs_vpc_dr
  private_subnets  = var.private_subnets_shared_service_chcs_vpc_dr
  private_dedicated_network_acl = var.private_dedicated_network_acl
  public_dedicated_network_acl = var.public_dedicated_network_acl
  
  tgw-route-cidr-1  = var.tgw-route-cidr-1_shared_service_chcs_vpc_dr
  tgw-route-cidr-2  = var.tgw-route-cidr-2_shared_service_chcs_vpc_dr
  tgw-route-cidr-3  = var.tgw-route-cidr-3_shared_service_chcs_vpc_dr
  tgw-route-cidr-4  = var.tgw-route-cidr-4_shared_service_chcs_vpc_dr
  tgw-route-cidr-5  = var.tgw-route-cidr-5_shared_service_chcs_vpc_dr
  tgw-route-cidr-6  = var.tgw-route-cidr-6_shared_service_chcs_vpc_dr
  tgw-route-cidr-7  = var.tgw-route-cidr-7_shared_service_chcs_vpc_dr
  tgw-route-cidr-8  = var.tgw-route-cidr-8_shared_service_chcs_vpc_dr

  transit_gateway_id                             = module.tgw.ec2_transit_gateway_id
  providers = {
    aws.dst = aws.chcs-shared-dr
  }
}

module "BASTION-VPC-SHARED-SERVICE-DR" {
  source  = "./../modules/vpc-module"
  name = var.name_bastion_vpc_shared_service_dr
  cidr = var.cidr_bastion_vpc_shared_service_dr
  azs             = var.azs_bastion_vpc_shared_service_dr
  public_subnets  = var.public_subnets_bastion_vpc_shared_service_dr
  public_dedicated_network_acl = var.public_dedicated_network_acl

  tgw-route-cidr-1  = var.tgw-route-cidr-1_bastion_vpc_shared_service_dr
  tgw-route-cidr-2  = var.tgw-route-cidr-2_bastion_vpc_shared_service_dr
  tgw-route-cidr-3  = var.tgw-route-cidr-3_bastion_vpc_shared_service_dr
  tgw-route-cidr-4  = var.tgw-route-cidr-4_bastion_vpc_shared_service_dr
  tgw-route-cidr-5  = var.tgw-route-cidr-5_bastion_vpc_shared_service_dr
  tgw-route-cidr-6  = var.tgw-route-cidr-6_bastion_vpc_shared_service_dr
  tgw-route-cidr-7  = var.tgw-route-cidr-7_bastion_vpc_shared_service_dr
  tgw-route-cidr-8  = var.tgw-route-cidr-8_bastion_vpc_shared_service_dr
  transit_gateway_id                             = module.tgw.ec2_transit_gateway_id
  providers = {
    aws.dst = aws.chcs-shared-dr
  }
}

/*
##########################################################################################
#  DR SECURITY GROUP FOR PROD ACCOUNT
#########################################################################################
module "sg-tgw" {
  source = "./../modules/aws-sg-tgw"
  security_group_name = "prod-dr-sg"
  vpc_id = module.HIPAA-CHCS-VPC-PROD-DR.vpc_id

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

    aws.dst = aws.chcs-prod-dr
  }
}

##########################################################################################
# DR SECURITY GROUP FOR NON-PROD ACCOUNT
#########################################################################################

module "sg-tgw-1" {
  source = "./../modules/aws-sg-tgw"
  security_group_name = "non-prod-dr-sg"
  vpc_id = module.PCI-CHCS-VPC-NON-PROD-DR.vpc_id

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

    aws.dst = aws.chcs-non-prod-dr
  }

}

##########################################################################################
#  DR SECURITY GROUP FOR TRANSIT ACCOUNT
#########################################################################################
module "sg-tgw-transit" {
  source = "./../modules/aws-sg-tgw"
  security_group_name = "transit-dr-sg"
  vpc_id = module.INSPECTION-VPC-TRANSIT-DR.vpc_id

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

    aws.dst = aws.chcs-transit-dr
  }
}

##########################################################################################
#  DR SECURITY GROUP FOR PCI ACCOUNT
#########################################################################################
module "sg-tgw-pci" {
  source = "./../modules/aws-sg-tgw"
  security_group_name = "pci-dr-sg"
  vpc_id = module.PCI-CHCS-VPC-PCI-DR.vpc_id

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
    aws.dst = aws.chcs-pci-dr
  }
}

##########################################################################################
#  DR SECURITY GROUP FOR SHARED SERVICE ACCOUNT
#########################################################################################
module "sg-tgw-shared" {
  source = "./../modules/aws-sg-tgw"
  security_group_name = "shared-service-dr-sg"
  vpc_id = module.SHARED-SERVICE-CHCS-VPC-DR.vpc_id

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

    aws.dst = aws.chcs-shared-dr
  }
}

##########################################################################################
# DR EC2 INSTANCE FOR PROD ACCOUNT
#########################################################################################

module "ec2-public-prod-dr" {
  source                        = "./../modules/aws-ec2"
  key_name                      = "transit-gateway-mark-1"
  public_key                    = file("./niba.pub")
  instance_count                = 1
  ami                           = "ami-0dc8f589abe99f538"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "true"
  root_volume_size              = 8
  subnet_ids                    = module.HIPAA-CHCS-VPC-PROD-DR.public_subnets
  vpc_security_group_ids        = [module.sg-tgw.aws_security_group]
  #iam_instance_profile          = module.s3-role-mark.aws_iam_s3_role
  ec2_tags                      = "prod-public-vm"
  providers = {
    aws.dst = aws.chcs-prod-dr
  }
  
}
module "ec2-private-prod-dr" {
  source                        = "./../modules/aws-ec2"
  key_name                      = "transit-gateway-mark"
  public_key                    = file("./niba-prv.pub")
  instance_count                = 1
  ami                           = "ami-0dc8f589abe99f538"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "false"
  root_volume_size              = 8
  subnet_ids                    = module.HIPAA-CHCS-VPC-PROD-DR.private_subnets
  vpc_security_group_ids        = [module.sg-tgw.aws_security_group]
  #iam_instance_profile          = module.s3-role-mark.aws_iam_s3_role
  ec2_tags                      = "prod-private-vm"
  providers = {
    aws.dst = aws.chcs-prod-dr
  }

}

##########################################################################################
# DR EC2 INSTANCE FOR NON-PROD ACCOUNT
#########################################################################################

module "ec2-public-nonprod-dr" {
  source                        = "./../modules/aws-ec2"
  key_name                      = "transit-gateway-chris-1"
  public_key                    = file("./niba.pub")
  instance_count                = 1
  ami                           = "ami-0dc8f589abe99f538"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "true"
  root_volume_size              = 8
  subnet_ids                    = module.PCI-CHCS-VPC-NON-PROD-DR.public_subnets
  vpc_security_group_ids        = [module.sg-tgw-1.aws_security_group]
  iam_instance_profile          = module.s3-role-chcs-non-prod-dr.aws_iam_s3_role
  ec2_tags                      = "non-prod-public-vm"
  providers = {
    aws.dst = aws.chcs-non-prod-dr
  }

}
     
module "ec2-private-nonprod-dr" {
  source                        = "./../modules/aws-ec2"
  key_name                      = "transit-gateway-chris"
  public_key                    = file("./niba-prv.pub")
  instance_count                = 1
  ami                           = "ami-0dc8f589abe99f538"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "false"
  root_volume_size              = 8
  subnet_ids                    = module.PCI-CHCS-VPC-NON-PROD-DR.private_subnets
  vpc_security_group_ids        = [module.sg-tgw-1.aws_security_group]
  iam_instance_profile          = module.s3-role-chcs-non-prod-dr.aws_iam_s3_role
  ec2_tags                      = "non-prod-private-vm"
  providers = {
    aws.dst = aws.chcs-non-prod-dr
  }

}

##########################################################################################
# DR EC2 INSTANCE FOR TRANSIT ACCOUNT
#########################################################################################

module "ec2-transit-account-public" {
  source                        = "./../modules/aws-ec2"
  key_name                      = "transit-gateway-chris-1"
  public_key                    = file("./niba.pub")
  instance_count                = 1
  ami                           = "ami-0dc8f589abe99f538"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "true"
  root_volume_size              = 8
  subnet_ids                    = module.INSPECTION-VPC-TRANSIT-DR.public_subnets
  vpc_security_group_ids        = [module.sg-tgw-transit.aws_security_group]
  #iam_instance_profile          = module.s3-role-chris.aws_iam_s3_role
  ec2_tags                      = "transit-public-vm"
  providers = {
    aws.dst = aws.chcs-transit-dr
  }
}

module "ec2-private-transit-account" {
  source                        = "./../modules/aws-ec2"
  key_name                      = "transit-gateway-chris"
  public_key                    = file("./niba-prv.pub")
  instance_count                = 1
  ami                           = "ami-0dc8f589abe99f538"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "false"
  root_volume_size              = 8
  subnet_ids                    = module.INSPECTION-VPC-TRANSIT-DR.private_subnets
  vpc_security_group_ids        = [module.sg-tgw-transit.aws_security_group]
 # iam_instance_profile          = module.s3-role-chris.aws_iam_s3_role
  ec2_tags                      = "transit-private-vm"
  providers = {
    aws.dst = aws.chcs-transit-dr
  }
}

##########################################################################################
# DR EC2 INSTANCE FOR PCI ACCOUNT
#########################################################################################

module "ec2-pci-account-public" {
  source                        = "./../modules/aws-ec2"
  key_name                      = "transit-gateway-pci-1"
  public_key                    = file("./niba.pub")
  instance_count                = 1
  ami                           = "ami-0dc8f589abe99f538"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "true"
  root_volume_size              = 8
  subnet_ids                    = module.PCI-CHCS-VPC-PCI-DR.public_subnets
  vpc_security_group_ids        = [module.sg-tgw-pci.aws_security_group]
  iam_instance_profile          = module.s3-role-chcs-pci-dr.aws_iam_s3_role
  ec2_tags                      = "pci-public-vm"
  providers = {
    aws.dst = aws.chcs-pci-dr
  }
}

module "ec2-private-pci-account" {
  source                        = "./../modules/aws-ec2"
  key_name                      = "transit-gateway-pci"
  public_key                    = file("./niba-prv.pub")
  instance_count                = 1
  ami                           = "ami-0dc8f589abe99f538"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "false"
  root_volume_size              = 8
  subnet_ids                    = module.PCI-CHCS-VPC-PCI-DR.private_subnets
  vpc_security_group_ids        = [module.sg-tgw-pci.aws_security_group]
  iam_instance_profile          = module.s3-role-chcs-pci-dr.aws_iam_s3_role
  ec2_tags                      = "pci-private-vm"
  providers = {
    aws.dst = aws.chcs-pci-dr
  }
}


##########################################################################################
# DR EC2 INSTANCE FOR SHARED SERVICE ACCOUNT
#########################################################################################

module "ec2-shared-account-public" {
  source                        = "./../modules/aws-ec2"
  key_name                      = "transit-gateway-chris-1"
  public_key                    = file("./niba.pub")
  instance_count                = 1
  ami                           = "ami-0dc8f589abe99f538"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "true"
  root_volume_size              = 8
  subnet_ids                    = module.SHARED-SERVICE-CHCS-VPC-DR.public_subnets
  vpc_security_group_ids        = [module.sg-tgw-shared.aws_security_group]
  #iam_instance_profile          = module.s3-role-chris.aws_iam_s3_role
  ec2_tags                      = "shared-public-vm"
  providers = {
    aws.dst = aws.chcs-shared-dr
  }
}

module "ec2-private-shared-account" {
  source                        = "./../modules/aws-ec2"
  key_name                      = "transit-gateway-chris"
  public_key                    = file("./niba-prv.pub")
  instance_count                = 1
  ami                           = "ami-0dc8f589abe99f538"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "false"
  root_volume_size              = 8
  subnet_ids                    = module.SHARED-SERVICE-CHCS-VPC-DR.private_subnets
  vpc_security_group_ids        = [module.sg-tgw-shared.aws_security_group]
 # iam_instance_profile          = module.s3-role-chris.aws_iam_s3_role
  ec2_tags                      = "shared-private-vm"
  providers = {
    aws.dst = aws.chcs-shared-dr
  }
}
*/

##############################################################################
# DR S3 ROLE FOR PROD ACCOUNT
###########################################################################

module "s3-role-chcs-prod-dr" {
  source     ="./../modules/s3-role"
  iam_role_name  =  ["s3-role-dr"] 
  iam_policy_name =  ["iam-policy-dr"]
  iam_policy_attachment_name = ["iam-attachment-policy-dr"]
  iam_instance_profile_name = ["iam-instance-profile-dr"]
  providers = {
    aws = aws.chcs-prod-dr
  }
}

##############################################################################
# DR S3 ROLE FOR NON-PROD ACCOUNT
###########################################################################

module "s3-role-chcs-non-prod-dr" {
  source     ="./../modules/s3-role"
  
  iam_role_name  =  ["s3-role-dr"] 
  iam_policy_name =  ["iam-policy-dr"]
  iam_policy_attachment_name = ["iam-attachment-policy-dr"]
  iam_instance_profile_name = ["iam-instance-profile-dr"]
  providers = {
    aws = aws.chcs-non-prod-dr
  }
}

##############################################################################
# DR S3 ROLE FOR TRANSIT ACCOUNT
###########################################################################
/*
module "s3-role-chcs-transit-dr" {
  source     ="./../modules/s3-role"

  iam_role_name  =  ["s3-role-dr"]
  iam_policy_name =  ["iam-policy-dr"]
  iam_policy_attachment_name = ["iam-attachment-policy-dr"]
  iam_instance_profile_name = ["iam-instance-profile-dr"]
  providers = {
    aws = aws.chcs-transit-dr
  }
}

##############################################################################
# DR S3 ROLE FOR SHARED SERVICE ACCOUNT
###########################################################################

module "s3-role-chcs-shared-service-dr" {
  source     ="./../modules/s3-role"

  iam_role_name  =  ["s3-role-dr"]
  iam_policy_name =  ["iam-policy-dr"]
  iam_policy_attachment_name = ["iam-attachment-policy-dr"]
  iam_instance_profile_name = ["iam-instance-profile-dr"]
  providers = {
    aws = aws.chcs-shared-dr
  }
}
*/
##############################################################################
# DR S3 ROLE FOR PCI ACCOUNT
###########################################################################

module "s3-role-chcs-pci-dr" {
  source     ="./../modules/s3-role"

  iam_role_name  =  ["s3-role-dr"]
  iam_policy_name =  ["iam-policy-dr"]
  iam_policy_attachment_name = ["iam-attachment-policy-dr"]
  iam_instance_profile_name = ["iam-instance-profile-dr"]
  providers = {
    aws = aws.chcs-pci-dr
  }
}


#########################################################################
# DR VPC ENDPOINT FOR PCI ACCOUNT
#########################################################################

module "PCI-CHCS-VPC-PCI-DR-ENDPOINT" {
  #source = "cloudposse/vpc/aws//modules/vpc-endpoints"
  source = "./../modules/vpc-endpoints"
  vpc-gateway-endpoint = "S3-PCI-CHCS-VPC-PCI-DR-ENDPOINT"
  vpc_id = module.PCI-CHCS-VPC-PCI-DR.vpc_id
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
      route_table_ids     = module.PCI-CHCS-VPC-PCI-DR.private_route_table_ids
    }
  }

#  interface_vpc_endpoints = {
#    "ec2" = {
#      name                = "ec2"
#      security_group_ids  = [module.sg-tgw.aws_security_group] 
#      subnet_ids          = module.PCI-CHCS-VPC-PCI-DR.private_subnets
#      policy              = null
#      private_dns_enabled = false
#    }
#  }

 providers = {
    aws = aws.chcs-pci-dr
   }
}

#########################################################################
#  DR VPC ENDPOINT FOR NON-PROD ACCOUNT
#########################################################################

module "PCI-CHCS-VPC-NON-PROD-DR-ENDPOINT" {
  source = "./../modules/vpc-endpoints"
  vpc_id = module.PCI-CHCS-VPC-NON-PROD-DR.vpc_id
  vpc-gateway-endpoint = "S3-PCI-CHCS-VPC-NON-PROD-DR-ENDPOINT"
  gateway_vpc_endpoints = {
    "s3" = {
      name = "s3"
      #name = "S3-PCI-CHCS-VPC-NON-PROD-DR-ENDPOINT"
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
      route_table_ids     = module.PCI-CHCS-VPC-NON-PROD-DR.private_route_table_ids
    }
  }

 providers = {
    aws = aws.chcs-non-prod-dr
   }
}

module "HIPAA-CHCS-VPC-NON-PROD-DR-ENDPOINT" {
  source = "./../modules/vpc-endpoints"
  vpc_id = module.HIPAA-CHCS-VPC-NON-PROD-DR.vpc_id
  vpc-gateway-endpoint = "S3-HIPAA-CHCS-VPC-NON-PROD-DR-ENDPOINT"  
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
      route_table_ids     = module.HIPAA-CHCS-VPC-NON-PROD-DR.private_route_table_ids
    }
  }
 providers = {
    aws = aws.chcs-non-prod-dr
   }
}

module "DEV-QA-UAT-CHCS-VPC-NON-PROD-DR-ENDPOINT" {
  source = "./../modules/vpc-endpoints"
  vpc_id = module.DEV-QA-UAT-CHCS-VPC-NON-PROD-DR.vpc_id
  vpc-gateway-endpoint = "S3-DEV-QA-UAT-CHCS-VPC-NON-PROD-DR-ENDPOINT"
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
      route_table_ids     = module.DEV-QA-UAT-CHCS-VPC-NON-PROD-DR.private_route_table_ids
    }
  }
 providers = {
    aws = aws.chcs-non-prod-dr
   }
}

