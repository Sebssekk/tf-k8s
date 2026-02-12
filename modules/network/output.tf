output "vpc_id" {
  value = local.vpc_id
  description = "Cluster VPC ID"
}

output "subnet_id" {
  value = local.subnet_id
  description = "Cluster Subnet ID"
}