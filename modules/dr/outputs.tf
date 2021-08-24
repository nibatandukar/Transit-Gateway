/*
output "vpc2_id" {
  value = module.vpc2.vpc_id
}
output "vpc3_id" {
  value = module.vpc3.vpc_id
}

output "vpc2_private_subnets" {
  description = "This is the private subnets of vpc2"
  value = module.vpc2.private_subnets
}

output "vpc3_private_subnets" {
  description = "This is the private subnets of vpc3"
  value = module.vpc3.private_subnets
}

output "prod-public-vm" {
  description = " This is the public IP of Prod account"
  value = module.ec2-public-prod-dr.public_ip
}

output "prod-private-vm" {
  description = " This is the private IP of prod account"
  value = module.ec2-private-prod-dr.private_ip
}

output "non-prod-public-vm" {
  description = " This is the public IP of non-prod account"
  value = module.ec2-public-nonprod-dr.public_ip
}

output "non-prod-private-vm" {
  description = " This is the private IP of non-prod account"
  value = module.ec2-private-nonprod-dr.private_ip
}

output "transit-public-vm" {
  description = " This is the private IP of Chris account"
  value = module.ec2-transit-account-public.public_ip
}

output "transit-private-vm" {
  description = " This is the private IP of Mark account"
  value = module.ec2-private-transit-account.private_ip
}

output "pci-public-vm" {
  description = " This is the private IP of Chris account"
  value = module.ec2-pci-account-public.public_ip
}

output "pci-private-vm" {
  description = " This is the private IP of Mark account"
  value = module.ec2-private-pci-account.private_ip
}

output "shared-public-vm" {
  description = " This is the private IP of Chris account"
  value = module.ec2-shared-account-public.public_ip
}

output "shared-private-vm" {
  description = " This is the private IP of Mark account"
  value = module.ec2-private-shared-account.private_ip
}
*/
