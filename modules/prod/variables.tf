variable "region" {
  default = "us-east-1"
}

variable "role_arn_shared" {
  default = "arn:aws:iam::279108474419:role/infra-automation-to-chcs-shareds"
}

variable "role_arn_transit" {
  default = "arn:aws:iam::205266265424:role/infra-automation-to-chcs-transit"
}

variable "role_arn_prod" {
  default = "arn:aws:iam::682258877194:role/infra-automation-to-chcs-prods"
}

variable "role_arn_non_prod" {
  default = "arn:aws:iam::551294210778:role/infra-automation-to-chcs-non-prods"
}


variable "role_arn_pci" {
  default = "arn:aws:iam::982631031626:role/infra-automation-to-chcs-pci"
}

##################TGW TRANSIT ACCOUNT#############################

variable "name_transit_tgw" {
  default = "TGW-TRANSIT-ACCOUNT"
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
  default = "TRANSIT-ACCOUNTS-TGW"
}


########################  PROD ACCOUNT  TGW PEER   ###################################

variable "name_prod_tgwpeer" {
  default = "TGW-PEER-PROD"
}

variable "description_prod_tgw" {
  default = "My TGW shared from transit account to prod accounts"
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

variable  "ram_principals_prod" {
  default = [682258877194]
}

variable "tags_prod_purpose" {
  default = "PROD-ACCOUNT-TGW"
}

######################## NON PROD ACCOUNT TGW PEER   ###################################

variable "name_non_prod_tgwpeer" {
  default = "TGW-PEER-NON-PROD"
}

variable "description_non_prod_tgw" {
  default = "My TGW shared from transit account to non prod accounts"
}

variable  "ram_principals_non_prod" {
  default = [551294210778]
}

variable "tags_non_prod_purpose" {
  default = "NON-PROD-ACCOUNT-TGW"
}

########################  PCI ACCOUNT TGW PEER   ###################################

variable "name_pci_tgwpeer" {
  default = "TGW-PEER-PCI"
}

variable "description_pci_tgw" {
  default = "My TGW shared from transit account to pci accounts"
}

variable  "ram_principals_pci" {
  default = [982631031626]
}

variable "tags_pci_purpose" {
  default = "PCI-ACCOUNT-TGW"
}

######################## SHARED ACCOUNT TGW PEER   ###################################

variable "name_shared_tgwpeer" {
  default = "TGW-PEER-SHARED"
}

variable "description_shared_tgw" {
  default = "My TGW shared from transit account to shared accounts"
}

variable  "ram_principals_shared" {
  default = [279108474419]
}

variable "tags_shared_purpose" {
  default = "SHARED-ACCOUNT-TGW"
}

######################## VPC TRANSIT ACCOUNT  ###################################

variable "name_inspection_vpc_transit" {
  default = "INSPECTION-VPC-TRANSIT"
}

variable "cidr_inspection_vpc_transit" {
  default = "10.90.0.0/21"
}

variable  "azs_inspection_vpc_transit" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets_inspection_vpc_transit" {
  default = ["10.90.2.0/24"]
}

variable "private_subnets_inspection_vpc_transit" {
  default =  ["10.90.0.0/24", "10.90.1.0/24", "10.90.6.0/24", "10.90.7.0/24"]
}

variable "tgw-route-cidr-1_inspection_vpc_transit" {
  default = "10.40.0.0/20"
}

variable "tgw-route-cidr-2_inspection_vpc_transit" {
  default = "10.50.0.0/21"
}

variable "tgw-route-cidr-3_inspection_vpc_transit" {
  default = "10.20.0.0/21"
}

variable "tgw-route-cidr-4_inspection_vpc_transit" {
  default = "10.20.8.0/21"
}

variable "tgw-route-cidr-5_inspection_vpc_transit" {
  default = "10.20.16.0/21"
}

variable "tgw-route-cidr-6_inspection_vpc_transit" {
  default = "10.30.0.0/21"
}

variable "tgw-route-cidr-7_inspection_vpc_transit" {
  default = "10.10.0.0/19"
}

variable "tgw-route-cidr-8_inspection_vpc_transit" {
  default = "192.168.0.0/24"
}

######################## VPC PROD ACCOUNT  ###################################

variable "name_shared_chcs_vpc_prod" {
  default = "SHARED-CHCS-VPC-PROD"
}

variable "cidr_shared_chcs_vpc_prod" {
  default = "10.40.0.0/20"
}

variable  "azs_shared_chcs_vpc_prod" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets_shared_chcs_vpc_prod" {
  default = ["10.40.0.0/24", "10.40.1.0/24", "10.40.8.0/24", "10.40.9.0/24", "10.40.6.0/24", "10.40.7.0/24"]
}

variable "private_subnets_shared_chcs_vpc_prod" {
  default = ["10.40.2.0/24", "10.40.3.0/24", "10.40.10.0/24" , "10.40.11.0/24", "10.40.4.0/24", "10.40.5.0/24"]
}

variable "tgw-route-cidr-1_shared_chcs_vpc_prod" {
  default = "10.90.0.0/21"
}

variable "tgw-route-cidr-2_shared_chcs_vpc_prod" {
  default = "10.50.0.0/21"
}

variable "tgw-route-cidr-3_shared_chcs_vpc_prod" {
  default = "10.20.0.0/21"
}

variable "tgw-route-cidr-4_shared_chcs_vpc_prod" {
  default = "10.20.8.0/21"
}

variable "tgw-route-cidr-5_shared_chcs_vpc_prod" {
  default = "10.20.16.0/21"
}

variable "tgw-route-cidr-6_shared_chcs_vpc_prod" {
  default = "10.30.0.0/21"
}

variable "tgw-route-cidr-7_shared_chcs_vpc_prod" {
  default = "10.10.0.0/19"
}

variable "tgw-route-cidr-8_shared_chcs_vpc_prod" {
  default = "192.168.0.0/24"
}

#####################################################################

variable "name_hipaa_chcs_vpc_prod" {
  default = "HIPAA-CHCS-VPC-PROD"
}

variable "cidr_hipaa_chcs_vpc_prod" {
  default = "10.50.0.0/21"
}

variable  "azs_hipaa_chcs_vpc_prod" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets_hipaa_chcs_vpc_prod" {
  default = ["10.50.0.0/24", "10.50.1.0/24"]
}

variable "private_subnets_hipaa_chcs_vpc_prod" {
  default = ["10.50.2.0/24", "10.50.3.0/24"]
}

variable "tgw-route-cidr-1_hipaa_chcs_vpc_prod" {
  default = "10.90.0.0/21"
}

variable "tgw-route-cidr-2_hipaa_chcs_vpc_prod" {
  default = "10.40.0.0/20"
}

variable "tgw-route-cidr-3_hipaa_chcs_vpc_prod" {
  default = "10.20.0.0/21"
}

variable "tgw-route-cidr-4_hipaa_chcs_vpc_prod" {
  default = "10.20.8.0/21"
}

variable "tgw-route-cidr-5_hipaa_chcs_vpc_prod" {
  default = "10.20.16.0/21"
}

variable "tgw-route-cidr-6_hipaa_chcs_vpc_prod" {
  default = "10.30.0.0/21"
}

variable "tgw-route-cidr-7_hipaa_chcs_vpc_prod" {
  default = "10.10.0.0/19"
}

variable "tgw-route-cidr-8_hipaa_chcs_vpc_prod" {
  default = "192.168.0.0/24"
}

######################## VPC NON PROD ACCOUNT  ###################################

variable "name_pci_chcs_vpc_non_prod" {
  default = "PCI-CHCS-VPC-NON-PROD"
}

variable "cidr_pci_chcs_vpc_non_prod" {
  default = "10.20.0.0/21"
}

variable  "azs_pci_chcs_vpc_non_prod" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets_pci_chcs_vpc_non_prod" {
  default = ["10.20.0.0/24", "10.20.1.0/24"]
}

variable "private_subnets_pci_chcs_vpc_non_prod" {
  default = ["10.20.2.0/24", "10.20.3.0/24"]
}

variable "tgw-route-cidr-1_pci_chcs_vpc_non_prod" {
  default = "10.90.0.0/21"
}

variable "tgw-route-cidr-2_pci_chcs_vpc_non_prod" {
  default = "10.40.0.0/20"
}

variable "tgw-route-cidr-3_pci_chcs_vpc_non_prod" {
  default = "10.50.0.0/21"
}

variable "tgw-route-cidr-4_pci_chcs_vpc_non_prod" {
  default = "10.20.8.0/21"
}

variable "tgw-route-cidr-5_pci_chcs_vpc_non_prod" {
  default = "10.20.16.0/21"
}

variable "tgw-route-cidr-6_pci_chcs_vpc_non_prod" {
  default = "10.30.0.0/21"
}

variable "tgw-route-cidr-7_pci_chcs_vpc_non_prod" {
  default = "10.10.0.0/19"
}

variable "tgw-route-cidr-8_pci_chcs_vpc_non_prod" {
  default = "192.168.0.0/24"
}

####################################################################

variable "name_hipaa_chcs_vpc_non_prod" {
  default = "HIPAA-CHCS-VPC-NON-PROD"
}

variable "cidr_hipaa_chcs_vpc_non_prod" {
  default = "10.20.8.0/21"
}

variable  "azs_hipaa_chcs_vpc_non_prod" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets_hipaa_chcs_vpc_non_prod" {
  default = ["10.20.8.0/24", "10.20.9.0/24"]
}

variable "private_subnets_hipaa_chcs_vpc_non_prod" {
  default = ["10.20.10.0/24", "10.20.11.0/24"]
}

variable "tgw-route-cidr-1_hipaa_chcs_vpc_non_prod" {
  default = "10.90.0.0/21"
}

variable "tgw-route-cidr-2_hipaa_chcs_vpc_non_prod" {
  default = "10.40.0.0/20"
}

variable "tgw-route-cidr-3_hipaa_chcs_vpc_non_prod" {
  default = "10.50.0.0/21"
}

variable "tgw-route-cidr-4_hipaa_chcs_vpc_non_prod" {
  default = "10.20.0.0/21"
}

variable "tgw-route-cidr-5_hipaa_chcs_vpc_non_prod" {
  default = "10.20.16.0/21"
}

variable "tgw-route-cidr-6_hipaa_chcs_vpc_non_prod" {
  default = "10.30.0.0/21"
}

variable "tgw-route-cidr-7_hipaa_chcs_vpc_non_prod" {
  default = "10.10.0.0/19"
}

variable "tgw-route-cidr-8_hipaa_chcs_vpc_non_prod" {
  default = "192.168.0.0/24"
}

####################################################################

variable "name_dev_qa_uat_chcs_vpc_non_prod" {
  default = "DEV-QA-UAT-CHCS-VPC-NON-PROD"
}

variable "cidr_dev_qa_uat_chcs_vpc_non_prod" {
  default = "10.20.16.0/21"
}

variable  "azs_dev_qa_uat_chcs_vpc_non_prod" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets_dev_qa_uat_chcs_vpc_non_prod" {
  default = ["10.20.16.0/24", "10.20.17.0/24"]
}

variable "private_subnets_dev_qa_uat_chcs_vpc_non_prod" {
  default = ["10.20.18.0/24", "10.20.19.0/24"]
}

variable "tgw-route-cidr-1_dev_qa_uat_chcs_vpc_non_prod" {
  default = "10.90.0.0/21"
}

variable "tgw-route-cidr-2_dev_qa_uat_chcs_vpc_non_prod" {
  default = "10.40.0.0/20"
}

variable "tgw-route-cidr-3_dev_qa_uat_chcs_vpc_non_prod" {
  default = "10.50.0.0/21"
}

variable "tgw-route-cidr-4_dev_qa_uat_chcs_vpc_non_prod" {
  default = "10.20.0.0/21"
}

variable "tgw-route-cidr-5_dev_qa_uat_chcs_vpc_non_prod" {
  default = "10.20.8.0/21"
}

variable "tgw-route-cidr-6_dev_qa_uat_chcs_vpc_non_prod" {
  default = "10.30.0.0/21"
}

variable "tgw-route-cidr-7_dev_qa_uat_chcs_vpc_non_prod" {
  default = "10.10.0.0/19"
}

variable "tgw-route-cidr-8_dev_qa_uat_chcs_vpc_non_prod" {
  default = "192.168.0.0/24"
}

########################## VPC PCI ACCOUNT #######################################

variable "name_pci_chcs_vpc_pci" {
  default = "PCI-CHCS-VPC-PCI"
}

variable "cidr_pci_chcs_vpc_pci" {
  default = "10.30.0.0/21"
}

variable  "azs_pci_chcs_vpc_pci" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets_pci_chcs_vpc_pci" {
  default = ["10.30.0.0/24", "10.30.1.0/24"]
}

variable "private_subnets_pci_chcs_vpc_pci" {
  default = ["10.30.2.0/24", "10.30.3.0/24"]
}

variable "tgw-route-cidr-1_pci_chcs_vpc_pci" {
  default = "10.90.0.0/21"
}

variable "tgw-route-cidr-2_pci_chcs_vpc_pci" {
  default = "10.40.0.0/20"
}

variable "tgw-route-cidr-3_pci_chcs_vpc_pci" {
  default = "10.50.0.0/21"
}

variable "tgw-route-cidr-4_pci_chcs_vpc_pci" {
  default = "10.20.0.0/21"
}

variable "tgw-route-cidr-5_pci_chcs_vpc_pci" {
  default = "10.20.8.0/21"
}

variable "tgw-route-cidr-6_pci_chcs_vpc_pci" {
  default = "10.20.16.0/21"
}

variable "tgw-route-cidr-7_pci_chcs_vpc_pci" {
  default = "10.10.0.0/19"
}

variable "tgw-route-cidr-8_pci_chcs_vpc_pci" {
  default = "192.168.0.0/24"
}

######################## VPC SHARED ACCOUNT  ###################################

variable "name_shared_service_chcs_vpc" {
  default = "SHARED-SERVICE-CHCS-VPC"
}

variable "cidr_shared_service_chcs_vpc" {
  default = "10.10.0.0/19"
}

variable  "azs_shared_service_chcs_vpc" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets_shared_service_chcs_vpc" {
  default = ["10.10.0.0/24", "10.10.1.0/24", "10.10.4.0/24", "10.10.5.0/24"]
}

variable "private_subnets_shared_service_chcs_vpc" {
  default = ["10.10.2.0/24", "10.10.3.0/24", "10.10.6.0/24", "10.10.7.0/24"]
}

variable "tgw-route-cidr-1_shared_service_chcs_vpc" {
  default = "10.90.0.0/21"
}

variable "tgw-route-cidr-2_shared_service_chcs_vpc" {
  default = "10.40.0.0/20"
}

variable "tgw-route-cidr-3_shared_service_chcs_vpc" {
  default = "10.50.0.0/21"
}

variable "tgw-route-cidr-4_shared_service_chcs_vpc" {
  default = "10.20.0.0/21"
}

variable "tgw-route-cidr-5_shared_service_chcs_vpc" {
  default = "10.20.8.0/21"
}

variable "tgw-route-cidr-6_shared_service_chcs_vpc" {
  default = "10.20.16.0/21"
}

variable "tgw-route-cidr-7_shared_service_chcs_vpc" {
  default = "10.30.0.0/21"
}

variable "tgw-route-cidr-8_shared_service_chcs_vpc" {
  default = "192.168.0.0/24"
}

###################################################################

variable "name_bastion_vpc_shared_service" {
  default = "BASTION-VPC-SHARED-SERVICE"
}

variable "cidr_bastion_vpc_shared_service" {
  default = "192.168.0.0/24"
}

variable  "azs_bastion_vpc_shared_service" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets_bastion_vpc_shared_service" {
  default = ["192.168.0.0/26", "192.168.0.64/26"]
}

variable "tgw-route-cidr-1_bastion_vpc_shared_service" {
  default = "10.90.0.0/21"
}

variable "tgw-route-cidr-2_bastion_vpc_shared_service" {
  default = "10.40.0.0/20"
}

variable "tgw-route-cidr-3_bastion_vpc_shared_service" {
  default = "10.50.0.0/21"
}

variable "tgw-route-cidr-4_bastion_vpc_shared_service" {
  default = "10.20.0.0/21"
}

variable "tgw-route-cidr-5_bastion_vpc_shared_service" {
  default = "10.20.8.0/21"
}

variable "tgw-route-cidr-6_bastion_vpc_shared_service" {
  default = "10.20.16.0/21"
}

variable "tgw-route-cidr-7_bastion_vpc_shared_service" {
  default = "10.30.0.0/21"
}

variable "tgw-route-cidr-8_bastion_vpc_shared_service" {
  default = "10.10.0.0/19"
}
