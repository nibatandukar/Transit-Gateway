# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# This is the configuration for Terragrunt, a thin wrapper for Terraform that helps keep your code DRY and
# maintainable: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder. If you're iterating
# locally, you can use --terragrunt-source /path/to/local/checkout/of/module to override the source parameter to a
# local check out of the module for faster iteration.
terraform {
  #source = "/home/sjoshi/chcs/modules/prod"
  source = "git@github.com:terraform-aws-modules/terraform-aws-transit-gateway.git"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}




# ---------------------------------------------------------------------------------------------------------------------
# Locals are named constants that are reusable within the configuration.
# ---------------------------------------------------------------------------------------------------------------------
locals {
  # Automatically load common variables shared across all accounts
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))

  # Extract the name prefix for easy access
  name_prefix = local.common_vars.locals.name_prefix

  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Extract the account_name for easy access
  account_name = local.account_vars.locals.account_name

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract the region for easy access
  aws_region = local.region_vars.locals.aws_region
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
# ---------------------------------------------------------------------------------------------------------------------

dependency "data_vpc1" {
  config_path = "../../vpc/shared-chcs-vpc-prod-dr"
}

dependency "data_vpc2" {
  config_path = "../../vpc/hippa-chcs-vpc-prod-dr"
}

dependency "data_tgw" {
  config_path = "../../../../transit/us-west-2/transit-gateway"
  
}

inputs = {
  name            = "TGW-PEER-NON-PROD-DR"
  description     = "My TGW shared from transit account to non prod dr  accounts"
  amazon_side_asn = 64532
  share_tgw       =  true
  create_tgw      =  false
  enable_auto_accept_shared_attachments = true # When "true" there is no need for RAM resources if using multiple AWS accounts
  
  ram_resource_share_arn = dependency.data_tgw.outputs.ram_resource_share_id
  vpc_attachments = {
    SHARED-CHCS-VPC-PROD-DR = {
      tgw_id      = dependency.data_tgw.outputs.ec2_transit_gateway_id
      vpc_id      = dependency.data_vpc1.outputs.vpc_id
      subnet_ids  = dependency.data_vpc1.outputs.public_subnets_0
      dns_support = true
    },
    HIPAA-CHCS-VPC-PROD-DR = {
      tgw_id      = dependency.data_tgw.outputs.ec2_transit_gateway_id
      vpc_id      = dependency.data_vpc2.outputs.vpc_id
      subnet_ids  = dependency.data_vpc2.outputs.public_subnets_0
      dns_support = true
    }
  }

  ram_allow_external_principals = true
  ram_principals = [682258877194]
}

