output "ec2_transit_gateway_id" {
  description = "EC2 Transit Gateway identifier"
  value       = module.tgw.ec2_transit_gateway_id
}

output "ec2_transit_gateway_route_table_id" {
  description = "EC2 Transit Gateway Route Table identifier"
  value       = module.tgw.ec2_transit_gateway_route_table_id
}

output "ram_resource_share_id" {
  description = "The Amazon Resource Name (ARN) of the resource share"
  value       = module.tgw.ram_resource_share_id
}

