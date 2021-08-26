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
  source = "../../../../modules//aws-sg-tgw/"
  #source = "git@github.com:terraform-aws-modules/terraform-aws-vpc.git"
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
  config_path = "../vpc/pci-chcs-vpc-pci-dr"
}

inputs = {
  security_group_name = "TGW-sg"
  vpc_id = dependency.data_vpc.outputs.vpc_id

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
}

