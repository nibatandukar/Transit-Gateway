# Set account-wide variables
locals {
  account_name = "infra-automation"
  domain_name = {
    name = "transit-gateway"
    properties = {
      created_outside_terraform = true
    }
  }
}

