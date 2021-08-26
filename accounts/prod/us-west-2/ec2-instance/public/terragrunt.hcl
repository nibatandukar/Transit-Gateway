# ---------------------------------------------------------------------------------------------------------------------

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder. If you're iterating
# locally, you can use --terragrunt-source /path/to/local/checkout/of/module to override the source parameter to a
# local check out of the module for faster iteration.
terraform {
  source = "../../../../../modules//aws-ec2/"
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
  config_path = "../../vpc/hippa-chcs-vpc-prod-dr"
}
dependency "data_sg" {
  config_path = "../../security-group"
}

inputs = {
  key_name                      = "transit-public"
  public_key                    = file("./key-pub.pub")
  instance_count                = 1
  ami                           = "ami-0dc8f589abe99f538"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = "true"
  root_volume_size              = 8
  subnet_ids                    = dependency.data_vpc.outputs.public_subnets
  vpc_security_group_ids        = [dependency.data_sg.outputs.aws_security_group]
  ec2_tags = "HIPPA-CHCS-VPC-PROD-DR-EC2-VM1"
  }

