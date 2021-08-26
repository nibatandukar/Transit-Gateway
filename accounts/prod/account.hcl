# Set account-wide variables
locals {
  account_name = "chcs-prod"
  profile = "chcs-prods"
  domain_name = {
    name = "prod-account"
    properties = {
      created_outside_terraform = true
    }
  }
}
