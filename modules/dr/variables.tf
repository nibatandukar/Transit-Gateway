variable "region" {
  default = "us-west-2"
}

variable "role_arn_shared_dr" {
  default = "arn:aws:iam::279108474419:role/infra-automation-to-chcs-shareds"
}

variable "role_arn_transit_dr" {
  default = "arn:aws:iam::205266265424:role/infra-automation-to-chcs-transit"
}

variable "role_arn_prod_dr" {
  default = "arn:aws:iam::682258877194:role/infra-automation-to-chcs-prods"
}

variable "role_arn_non_prod_dr" {
  default = "arn:aws:iam::551294210778:role/infra-automation-to-chcs-non-prods"
}

variable "role_arn_pci_dr" {
  default = "arn:aws:iam::982631031626:role/infra-automation-to-chcs-pci"
}

##################TGW TRANSIT ACCOUNT#############################

variable "name_transit_tgw" {
  default = "TGW-TRANSIT-ACCOUNT-DR"
}

variable "description_transit_tgw" {
  default = "My TGW shared with several other AWS accounts"
}

variable "amazon_side_asn_transit" {
  default = "64532"
}

variable "enable_auto_accept_shared_attachments_transit" {
  description = "When true there is no need for RAM resources if using multiple AWS accounts"
  type        = bool
  default     = true
}

variable "ram_allow_external_principals" {
  default = "true"
}

variable  "ram_principals_transit" {
  default = [682258877194, 551294210778, 530420366225, 279108474419, 982631031626]
}

variable "tags_transit_purpose" {
  default = "TRANSIT-ACCOUNT-TGW"
}

########################  PRDO ACCOUNT DR TGW PEER   ###################################

variable "name_prod_dr_tgwpeer" {
  default = "TGW-PEER-PROD-DR"
}

variable "description_prod_dr_tgw" {
  default = "My TGW shared from transit account to prod account"
}


variable "share_tgw" {
  default = "true"
}

variable "create_tgw" {
  default = "false"
}

variable "dns_support" {
  default     = "true"
}

variable  "ram_principals_prod_dr" {
  default = [682258877194]
} 

variable "tags_prod_dr_purpose" {
  default = "PROD-DR-ACCOUNT-TGW"
}
########################  NON PROD ACCOUNT DR TGW PEER   ###################################

variable "name_nonprod_dr_tgwpeer" {
  default = "TGW-PEER-NON-PROD-DR"
}

variable "description_nonprod_dr_tgw" {
  default = "My TGW shared from transit account to non prod account"
}

variable  "ram_principals_nonprod_dr" {
  default = [551294210778]
}

variable "tags_nonprod_dr_purpose" {
  default = "NON-PROD-DR-ACCOUNT-TGW"
}

########################  SHARED ACCOUNT DR TGW PEER   ###################################

variable "name_pci_dr_tgwpeer" {
  default = "TGW-PEER-PCI-DR"
}

variable "description_pci_dr_tgw" {
  default = "My TGW shared from transit account to pci account"
}

variable  "ram_principals_pci_dr" {
  default = [982631031626]
}

variable "tags_pci_dr_purpose" {
  default = "PCI-DR-ACCOUNT-TGW"
}

########################  SHARED ACCOUNT DR TGW PEER   ###################################

variable "name_shared_dr_tgwpeer" {
  default = "TGW-PEER-SHARED-DR"
}

variable "description_shared_dr_tgw" {
  default = "My TGW shared from transit account to shared account"
}

variable  "ram_principals_shared_dr" {
  default = [279108474419]
}

variable "tags_shared_dr_purpose" {
  default = "SHARED-DR-ACCOUNT-TGW"
}

######################## DR VPC TRANSIT ACCOUNT  ###################################

variable "name_inspection_vpc_transit_dr" {
  default = "INSPECTION-VPC-TRANSIT-DR"
}

variable "cidr_inspection_vpc_transit_dr" {
  default = "10.91.0.0/21"
}

variable  "azs_inspection_vpc_transit_dr" {
  default = ["us-west-2a", "us-west-2b"]
}

variable "private_subnets_inspection_vpc_transit_dr" {
  #default = ["10.91.1.0/24", "10.91.2.0/24", "10.91.8.0/24", "10.91.9.0/24"]
  default = ["10.91.1.0/24", "10.91.2.0/24", "10.91.6.0/24", "10.91.7.0/24"]
}

variable "public_subnets_inspection_vpc_transit_dr" {
  default = ["10.91.0.0/24"]
}

variable "tgw-route-cidr-1_inspection_vpc_transit_dr" {
  default = "10.41.0.0/20"
}

variable "tgw-route-cidr-2_inspection_vpc_transit_dr" {
  default = "10.51.0.0/21"
}

variable "tgw-route-cidr-3_inspection_vpc_transit_dr" {
  default = "10.21.0.0/21"
}

variable "tgw-route-cidr-4_inspection_vpc_transit_dr" {
  default = "10.21.8.0/21"
}

variable "tgw-route-cidr-5_inspection_vpc_transit_dr" {
  default = "10.21.16.0/21"
}

variable "tgw-route-cidr-6_inspection_vpc_transit_dr" {
  default = "10.31.0.0/21"
}

variable "tgw-route-cidr-7_inspection_vpc_transit_dr" {
  default = "10.11.0.0/19"
}

variable "tgw-route-cidr-8_inspection_vpc_transit_dr" {
  default = "192.168.1.0/24"
}

######################## DR VPC PROD ACCOUNT  ###################################

variable "name_shared_chcs_vpc_prod_dr" {
  default = "SHARED-CHCS-VPC-PROD-DR"
}

variable "cidr_shared_chcs_vpc_prod_dr" {
  default = "10.41.0.0/20"
}

variable  "azs_shared_chcs_vpc_prod_dr" {
  default = ["us-west-2a", "us-west-2b"]
}

variable "public_subnets_shared_chcs_vpc_prod_dr" {
  #default = ["10.41.0.0/24", "10.41.1.0/24", "10.41.8.0/24", "10.41.9.0/24", "10.41.16.0/24", "10.41.17.0/24"]
  default = ["10.41.0.0/24", "10.41.1.0/24", "10.41.4.0/24", "10.41.5.0/24", "10.41.6.0/24", "10.41.7.0/24"]
}

variable "private_subnets_shared_chcs_vpc_prod_dr" {
  #default = ["10.41.2.0/24", "10.41.3.0/24", "10.41.10.0/24", "10.41.11.0/24", "10.41.18.0/24", "10.41.19.0/24"]
  default = ["10.41.2.0/24", "10.41.3.0/24", "10.41.8.0/24", "10.41.9.0/24", "10.41.10.0/24", "10.41.11.0/24"]
}

variable "tgw-route-cidr-1_shared_chcs_vpc_prod_dr" {
  default = "10.91.0.0/21"
}

variable "tgw-route-cidr-2_shared_chcs_vpc_prod_dr" {
  default = "10.51.0.0/21"
}

variable "tgw-route-cidr-3_shared_chcs_vpc_prod_dr" {
  default = "10.21.0.0/21"
}

variable "tgw-route-cidr-4_shared_chcs_vpc_prod_dr" {
  default = "10.21.8.0/21"
}

variable "tgw-route-cidr-5_shared_chcs_vpc_prod_dr" {
  default = "10.21.16.0/21"
}

variable "tgw-route-cidr-6_shared_chcs_vpc_prod_dr" {
  default = "10.31.0.0/21"
}

variable "tgw-route-cidr-7_shared_chcs_vpc_prod_dr" {
  default = "10.11.0.0/19"
}

variable "tgw-route-cidr-8_shared_chcs_vpc_prod_dr" {
  default = "192.168.1.0/24"
}

###########################################################

variable "name_hipaa_chcs_vpc_prod_dr" {
  default = "HIPAA-CHCS-VPC-PROD-DR"
}

variable "cidr_hipaa_chcs_vpc_prod_dr" {
  default = "10.51.0.0/21"
}

variable  "azs_hipaa_chcs_vpc_prod_dr" {
  default = ["us-west-2a", "us-west-2b"]
}

variable "public_subnets_hipaa_chcs_vpc_prod_dr" {
  default = ["10.51.0.0/24", "10.51.1.0/24"]
}

variable "private_subnets_hipaa_chcs_vpc_prod_dr" {
  default = ["10.51.2.0/24", "10.51.3.0/24"]
}

variable "tgw-route-cidr-1_hipaa_chcs_vpc_prod_dr" {
  default = "10.91.0.0/21"
}

variable "tgw-route-cidr-2_hipaa_chcs_vpc_prod_dr" {
  default = "10.41.0.0/20"
}

variable "tgw-route-cidr-3_hipaa_chcs_vpc_prod_dr" {
  default = "10.21.0.0/21"
}

variable "tgw-route-cidr-4_hipaa_chcs_vpc_prod_dr" {
  default = "10.21.8.0/21"
}

variable "tgw-route-cidr-5_hipaa_chcs_vpc_prod_dr" {
  default = "10.21.16.0/21"
}

variable "tgw-route-cidr-6_hipaa_chcs_vpc_prod_dr" {
  default = "10.31.0.0/21"
}

variable "tgw-route-cidr-7_hipaa_chcs_vpc_prod_dr" {
  default = "10.11.0.0/19"
}

variable "tgw-route-cidr-8_hipaa_chcs_vpc_prod_dr" {
  default = "192.168.1.0/24"
}

######################## DR VPC NON PROD ACCOUNT  ###################################

variable "name_pci_chcs_vpc_non_prod_dr" {
  default = "PCI-CHCS-VPC-NON-PROD-DR"
}

variable "cidr_pci_chcs_vpc_non_prod_dr" {
  default = "10.21.0.0/21"
}

variable  "azs_pci_chcs_vpc_non_prod_dr" {
  default = ["us-west-2a", "us-west-2b"]
}

variable "public_subnets_pci_chcs_vpc_non_prod_dr" {
  default = ["10.21.0.0/24", "10.21.1.0/24"]
}

variable "private_subnets_pci_chcs_vpc_non_prod_dr" {
  default = ["10.21.2.0/24", "10.21.3.0/24"]
}

variable "tgw-route-cidr-1_pci_chcs_vpc_non_prod_dr" {
  default = "10.91.0.0/21"
}

variable "tgw-route-cidr-2_pci_chcs_vpc_non_prod_dr" {
  default = "10.41.0.0/20"
}

variable "tgw-route-cidr-3_pci_chcs_vpc_non_prod_dr" {
  default = "10.51.0.0/21"
}

variable "tgw-route-cidr-4_pci_chcs_vpc_non_prod_dr" {
  default = "10.21.8.0/21"
}

variable "tgw-route-cidr-5_pci_chcs_vpc_non_prod_dr" {
  default = "10.21.16.0/21"
}

variable "tgw-route-cidr-6_pci_chcs_vpc_non_prod_dr" {
  default = "10.31.0.0/21"
}

variable "tgw-route-cidr-7_pci_chcs_vpc_non_prod_dr" {
  default = "10.11.0.0/19"
}

variable "tgw-route-cidr-8_pci_chcs_vpc_non_prod_dr" {
  default = "192.168.1.0/24"
}

#####################################################

variable "name_hipaa_chcs_vpc_non_prod_dr" {
  default = "HIPAA-CHCS-VPC-NON-PROD-DR"
}

variable "cidr_hipaa_chcs_vpc_non_prod_dr" {
  default = "10.21.8.0/21"
}

variable  "azs_hipaa_chcs_vpc_non_prod_dr" {
  default = ["us-west-2a", "us-west-2b"]
}

variable "public_subnets_hipaa_chcs_vpc_non_prod_dr" {
  default = ["10.21.8.0/24", "10.21.9.0/24"]
}

variable "private_subnets_hipaa_chcs_vpc_non_prod_dr" {
  default = ["10.21.10.0/24", "10.21.11.0/24"]
}

variable "tgw-route-cidr-1_hipaa_chcs_vpc_non_prod_dr" {
  default = "10.91.0.0/21"
}

variable "tgw-route-cidr-2_hipaa_chcs_vpc_non_prod_dr" {
  default = "10.41.0.0/20"
}

variable "tgw-route-cidr-3_hipaa_chcs_vpc_non_prod_dr" {
  default = "10.51.0.0/21"
}

variable "tgw-route-cidr-4_hipaa_chcs_vpc_non_prod_dr" {
  default = "10.21.0.0/21"
}

variable "tgw-route-cidr-5_hipaa_chcs_vpc_non_prod_dr" {
  default = "10.21.16.0/21"
}

variable "tgw-route-cidr-6_hipaa_chcs_vpc_non_prod_dr" {
  default = "10.31.0.0/21"
}

variable "tgw-route-cidr-7_hipaa_chcs_vpc_non_prod_dr" {
  default = "10.11.0.0/19"
}

variable "tgw-route-cidr-8_hipaa_chcs_vpc_non_prod_dr" {
  default = "192.168.1.0/24"
}

#####################################################

variable "name_dev_qa_uat_chcs_vpc_non_prod_dr" {
  default = "DEV-QA-UAT-CHCS-VPC-NON-PROD-DR"
}

variable "cidr_dev_qa_uat_chcs_vpc_non_prod_dr" {
  default = "10.21.16.0/21"
}

variable  "azs_dev_qa_uat_chcs_vpc_non_prod_dr" {
  default = ["us-west-2a", "us-west-2b"]
}

variable "public_subnets_dev_qa_uat_chcs_vpc_non_prod_dr" {
  default = ["10.21.16.0/24", "10.21.17.0/24"]
}

variable "private_subnets_dev_qa_uat_chcs_vpc_non_prod_dr" {
  default = ["10.21.18.0/24", "10.21.19.0/24"]
}

variable "tgw-route-cidr-1_dev_qa_uat_chcs_vpc_non_prod_dr" {
  default = "10.91.0.0/21"
}

variable "tgw-route-cidr-2_dev_qa_uat_chcs_vpc_non_prod_dr" {
  default = "10.41.0.0/20"
}

variable "tgw-route-cidr-3_dev_qa_uat_chcs_vpc_non_prod_dr" {
  default = "10.51.0.0/21"
}

variable "tgw-route-cidr-4_dev_qa_uat_chcs_vpc_non_prod_dr" {
  default = "10.21.0.0/21"
}

variable "tgw-route-cidr-5_dev_qa_uat_chcs_vpc_non_prod_dr" {
  default = "10.21.8.0/21"
}

variable "tgw-route-cidr-6_dev_qa_uat_chcs_vpc_non_prod_dr" {
  default = "10.31.0.0/21"
}

variable "tgw-route-cidr-7_dev_qa_uat_chcs_vpc_non_prod_dr" {
  default = "10.11.0.0/19"
}

variable "tgw-route-cidr-8_dev_qa_uat_chcs_vpc_non_prod_dr" {
  default = "192.168.1.0/24"
}

######################## DR VPC PCI ACCOUNT  ###################################

variable "name_pci_chcs_vpc_pci_dr" {
  default = "PCI-CHCS-VPC-PCI-DR"
}

variable "cidr_pci_chcs_vpc_pci_dr" {
  default = "10.31.0.0/21"
}

variable  "azs_pci_chcs_vpc_pci_dr" {
  default = ["us-west-2a", "us-west-2b"]
}

variable "public_subnets_pci_chcs_vpc_pci_dr" {
  default = ["10.31.0.0/24", "10.31.1.0/24"]
}

variable "private_subnets_pci_chcs_vpc_pci_dr" {
  default = ["10.31.2.0/24", "10.31.3.0/24"]
}

variable "tgw-route-cidr-1_pci_chcs_vpc_pci_dr" {
  default = "10.91.0.0/21"
}

variable "tgw-route-cidr-2_pci_chcs_vpc_pci_dr" {
  default = "10.41.0.0/20"
}

variable "tgw-route-cidr-3_pci_chcs_vpc_pci_dr" {
  default = "10.51.0.0/21"
}

variable "tgw-route-cidr-4_pci_chcs_vpc_pci_dr" {
  default = "10.21.0.0/21"
}

variable "tgw-route-cidr-5_pci_chcs_vpc_pci_dr" {
  default = "10.21.8.0/21"
}

variable "tgw-route-cidr-6_pci_chcs_vpc_pci_dr" {
  default = "10.21.16.0/21"
}

variable "tgw-route-cidr-7_pci_chcs_vpc_pci_dr" {
  default = "10.11.0.0/19"
}

variable "tgw-route-cidr-8_pci_chcs_vpc_pci_dr" {
  default = "192.168.1.0/24"
}


######################## DR VPC SHARED ACCOUNT  ###################################

variable "name_shared_service_chcs_vpc_dr" {
  default = "SHARED-SERVICE-CHCS-VPC-DR"
}

variable "cidr_shared_service_chcs_vpc_dr" {
  default = "10.11.0.0/19"
}

variable  "azs_shared_service_chcs_vpc_dr" {
  default = ["us-west-2a", "us-west-2b"]
}

variable "public_subnets_shared_service_chcs_vpc_dr" {
  #default = ["10.11.0.0/24", "10.11.1.0/24", "10.11.8.0/24", "10.11.9.0/24"]
  default = ["10.11.0.0/24", "10.11.1.0/24", "10.11.4.0/24", "10.11.5.0/24"]
}

variable "private_subnets_shared_service_chcs_vpc_dr" {
  #default = ["10.11.2.0/24", "10.11.3.0/24", "10.11.10.0/24", "10.11.11.0/24"]
  default = ["10.11.2.0/24", "10.11.3.0/24", "10.11.6.0/24", "10.11.7.0/24"]
}

variable "tgw-route-cidr-1_shared_service_chcs_vpc_dr" {
  default = "10.91.0.0/21"
}

variable "tgw-route-cidr-2_shared_service_chcs_vpc_dr" {
  default = "10.41.0.0/20"
}

variable "tgw-route-cidr-3_shared_service_chcs_vpc_dr" {
  default = "10.51.0.0/21"
}

variable "tgw-route-cidr-4_shared_service_chcs_vpc_dr" {
  default = "10.21.0.0/21"
}

variable "tgw-route-cidr-5_shared_service_chcs_vpc_dr" {
  default = "10.21.8.0/21"
}

variable "tgw-route-cidr-6_shared_service_chcs_vpc_dr" {
  default = "10.21.16.0/21"
}

variable "tgw-route-cidr-7_shared_service_chcs_vpc_dr" {
  default = "10.31.0.0/21"
}

variable "tgw-route-cidr-8_shared_service_chcs_vpc_dr" {
  default = "192.168.1.0/24"
}

#######################################################

variable "name_bastion_vpc_shared_service_dr" {
  default = "BASTION-VPC-SHARED-SERVICE-DR"
}

variable "cidr_bastion_vpc_shared_service_dr" {
  default = "192.168.1.0/24"
}

variable  "azs_bastion_vpc_shared_service_dr" {
  default = ["us-west-2a", "us-west-2b"]
}

variable "public_subnets_bastion_vpc_shared_service_dr" {
  default = ["192.168.1.0/26", "192.168.1.64/26"]
}

variable "tgw-route-cidr-1_bastion_vpc_shared_service_dr" {
  default = "10.91.0.0/21"
}

variable "tgw-route-cidr-2_bastion_vpc_shared_service_dr" {
  default = "10.41.0.0/20"
}

variable "tgw-route-cidr-3_bastion_vpc_shared_service_dr" {
  default = "10.51.0.0/21"
}

variable "tgw-route-cidr-4_bastion_vpc_shared_service_dr" {
  default = "10.21.0.0/21"
}

variable "tgw-route-cidr-5_bastion_vpc_shared_service_dr" {
  default = "10.21.8.0/21"
}

variable "tgw-route-cidr-6_bastion_vpc_shared_service_dr" {
  default = "10.21.16.0/21"
}

variable "tgw-route-cidr-7_bastion_vpc_shared_service_dr" {
  default = "10.31.0.0/21"
}

variable "tgw-route-cidr-8_bastion_vpc_shared_service_dr" {
  default = "10.11.0.0/19"
}

######################### Network ACL ####################

variable "public_dedicated_network_acl" {
  default = true
}

variable "private_dedicated_network_acl" {
  default = true
}

/*
variable "public_network_acl_egress" {
  default = [
    {
      rule_no    = 100
      action     = "allow"
      from_port  = 22
      to_port    = 22
      protocol   = "tcp"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no    = 200
      action     = "allow"
      from_port  = -1
      to_port    = -1
      protocol   = "icmp"
      cidr_block = "0.0.0.0/0"
    },
  ]
}

variable "public_network_acl_ingress" {
  default = [
    {
      rule_no    = 100
      action     = "allow"
      from_port  = 22
      to_port    = 22
      protocol   = "tcp"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no    = 200
      action     = "allow"
      from_port  = -1
      to_port    = -1
      protocol   = "icmp"
      cidr_block = "0.0.0.0/0"
    },
  ]
}

variable "private_network_acl_egress" {
  default = [
    {
      rule_no    = 100
      action     = "allow"
      from_port  = 22
      to_port    = 22
      protocol   = "tcp"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no    = 200
      action     = "allow"
      from_port  = -1
      to_port    = -1
      protocol   = "icmp"
      cidr_block = "0.0.0.0/0"
    },
  ]
}

variable "private_network_acl_ingress" {
  default = [
    {
      rule_no    = 100
      action     = "allow"
      from_port  = 22
      to_port    = 22
      protocol   = "tcp"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no    = 200
      action     = "allow"
      from_port  = -1
      to_port    = -1
      protocol   = "icmp"
      cidr_block = "0.0.0.0/0"
    },
  ]
}
*/
