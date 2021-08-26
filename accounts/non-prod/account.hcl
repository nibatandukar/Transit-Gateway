# Set account-wide variables
locals {
  account_name = "chcs-non-prod"
  profile = "chcs-non-prods"
  domain_name = {
    name = "non-prod-account"
    properties = {
      created_outside_terraform = true
    }
  }
}

