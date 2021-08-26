# Set account-wide variables
locals {
  account_name = "chcs-shared-service"
  profile = "chcs-shareds"
  domain_name = {
    name = "shared-service-account"
    properties = {
      created_outside_terraform = true
    }
  }
}

