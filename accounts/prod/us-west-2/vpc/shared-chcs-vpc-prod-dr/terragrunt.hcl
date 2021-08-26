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
  source = "../../../../../modules//vpc-module/"
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

inputs = {
  name = "SHARED-CHCS-VPC-PROD-DR"
  cidr = "10.41.0.0/20"
  azs             = ["us-west-2a", "us-west-2b"]
  public_subnets = ["10.41.0.0/24", "10.41.1.0/24", "10.41.4.0/24", "10.41.5.0/24", "10.41.6.0/24", "10.41.7.0/24"]
  private_subnets  = ["10.41.2.0/24", "10.41.3.0/24", "10.41.8.0/24", "10.41.9.0/24", "10.41.10.0/24", "10.41.11.0/24"]
  private_dedicated_network_acl = true
  public_dedicated_network_acl = true

}
