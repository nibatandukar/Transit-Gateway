# Set account-wide variables
locals {
  account_name = "chcs-pci"
  profile = "chcs-pci"
  domain_name = {
    name = "pci-account"
    properties = {
      created_outside_terraform = true
    }
  }
}

