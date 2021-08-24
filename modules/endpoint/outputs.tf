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

output "Chirs_EC_VM_Public_IP" {
  description = " This is the public IP of Chri account"
  value = module.ec2-transit-gateway-public-1.public_ip
}
*/
output "Mark_EC_VM_Public_IP" {
  description = " This is the public IP of Mark account"
  value = module.ec2-transit-gateway-public.public_ip
}
/*
output "Chirs_EC_VM_Private_IP" {
  description = " This is the private IP of Chris account"
  value = module.ec2-transit-gateway-public-1.private_ip
}
*/
output "Mark_EC_VM_Private_IP" {
  description = " This is the private IP of Mark account"
  value = module.ec2-transit-gateway-public.private_ip
}
/*
output "Chirs_EC_VM_Private_IP_Only" {
  description = " This is the private IP of Chris account"
  value = module.ec2-private-chris.private_ip
}
*/
output "Mark_EC_VM_Private_IP_Only" {
  description = " This is the private IP of Mark account"
  value = module.ec2-private-mark.private_ip
}
