output "vpc1_id" {
  value = module.vpc1.vpc_id
}
output "vpc1_private_subnets" {
  value = module.vpc1.private_subnets
}
output "aws_region" {
  description = "AWS region"
  value       = data.aws_region.current.name
}
