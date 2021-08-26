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
  source = "../../../../../modules//vpc-module-single/"
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
/*
dependency "acc_transit" {
  config_path = "../transit-gateway"
  mock_outputs = {
    ec2_transit_gateway_id = "dkiedwsd"
  }
  mock_outputs_allowed_terraform_commands = ["validate", ]
}
*/

inputs = {
  name = "INSPECTION-VPC-TRANSIT"
  cidr = "10.90.0.0/21"
  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets = ["10.90.2.0/24"]
  private_subnets  = ["10.90.0.0/24", "10.90.1.0/24", "10.90.6.0/24", "10.90.7.0/24"]
  private_dedicated_network_acl = true
  public_dedicated_network_acl = true
/*
  tgw-route-cidr-1   = "10.40.0.0/20"
  tgw-route-cidr-2   = "10.50.0.0/21"
  tgw-route-cidr-3   = "10.20.0.0/21"
  tgw-route-cidr-4   = "10.20.8.0/21"
  tgw-route-cidr-5   = "10.20.16.0/21"
  tgw-route-cidr-6   = "10.30.0.0/21"
  tgw-route-cidr-7   = "10.10.0.0/19"
  tgw-route-cidr-8   = "192.168.0.0/24"

  #transit_gateway_id = "tgw-004df25a2eb960649"
  transit_gateway_id = dependency.acc_transit.outputs.ec2_transit_gateway_id
*/
}