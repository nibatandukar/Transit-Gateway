output "vpc2_id" {
  value = module.vpc2.vpc_id
}
output "vpc2_private_subnets" {
  value = module.vpc2.private_subnets
}
output "aws_region" {
  description = "AWS region"
  value       = data.aws_region.current.name
}
