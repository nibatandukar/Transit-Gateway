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

output "Transit_EC_VM_Public_IP" {
  description = " This is the public IP of Transit account"
  value = module.ec2-transit-public.public_ip
}

output "Transit_EC_VM_Private_IP" {
  description = " This is the private IP of Transit account"
  value = module.ec2-transit-private.private_ip
}

output "Prod_EC_VM_Public_IP" {
  description = " This is the public IP of Prod account"
  value = module.ec2-prod-public.public_ip
}

output "Prod_EC_VM_Private_IP" {
  description = " This is the private IP of Prod account"
  value = module.ec2-prod-private.private_ip
}

output "Non_Prod_EC_VM_Public_IP" {
  description = " This is the public IP of Non Prod account"
  value = module.ec2-non-prod-public.public_ip
}

output "Non_Prod_EC_VM_Private_IP" {
  description = " This is the private IP of Non Prod account"
  value = module.ec2-non-prod-private.private_ip
}

output "Shared_EC_VM_Public_IP" {
  description = " This is the public IP of Shared account"
  value = module.ec2-shared-public.public_ip
}

output "Shared_EC_VM_Private_IP" {
  description = " This is the private IP of Shared account"
  value = module.ec2-shared-private.private_ip
}

output "Pci_EC_VM_Public_IP" {
  description = " This is the public IP of Pci account"
  value = module.ec2-pci-public.public_ip
}

output "Pci_EC_VM_Private_IP" {
  description = "This is the private IP of Pci account"
  value = module.ec2-pci-private.private_ip
}
*/

/*
output "Inbound_Private_Subnet" {
  description = "Gives output of only one subnets"
  value = module.INBOUND-VPC-TRANSIT-PROD.private_subnets_1
}
*/
