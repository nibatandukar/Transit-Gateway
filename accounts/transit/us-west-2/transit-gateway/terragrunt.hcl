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
  #source = "../../../../working-test-1/working-test/prod/"
  #source = "../../../../../gitlab/dr/vpc/ProdVPC"
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
dependency "data_vpc" {
  config_path = "../vpc/inspection-vpc-transit-dr"
}

inputs = {
  name            = "CHCS-TRANSIT-GATEWAY"
  description     = "TGW"
  amazon_side_asn = 64532

  enable_auto_accept_shared_attachments = true # When "true" there is no need for RAM resources if using multiple AWS accounts
  vpc_attachments = {
    INSPECTION-VPC-TRANSIT-DR = {
      #vpc_id     = "vpc-0f3e6bc9c79e02ff1"
      vpc_id     = dependency.data_vpc.outputs.vpc_id
      #subnet_ids = ["subnet-0dbf07ea68a54ef8d"]
      subnet_ids = dependency.data_vpc.outputs.private_subnets_0
    }
  }

  ram_allow_external_principals = true
  #ram_principals = [205266265424]
  ram_principals = [682258877194, 551294210778, 530420366225, 279108474419, 982631031626]
}
