# Set account-wide variables
locals {
  account_name = "chcs-transits"
  profile = "chcs-transits"
  domain_name = {
    name = "transit-account"
    properties = {
      created_outside_terraform = true
    }
  }
}

