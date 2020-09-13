##########
# Outputs
##########

output "vpc_name" {
  value       = ibm_is_vpc.vpc.name
  description = "The name of the vpc."
}

output "vpc_id" {
  value       = ibm_is_vpc.vpc.id
  description = "The ID of the vpc."
}

# output "vpc_subnets" {
#   value       = ibm_is_vpc.vpc.subnets
#   description = "A list of subnets that are attached to a VPC."
# }

output "cluster_name" {
  value       = ibm_container_vpc_cluster.cluster.name
  description = "The name of the cluster."
}

output "cluster_id" {
  value       = ibm_container_vpc_cluster.cluster.id
  description = "The ID of the cluster."
}

output "cluster_public_service_endpoint_url" {
  value       = ibm_container_vpc_cluster.cluster.public_service_endpoint_url
  description = "The public service endpoint URL."
}

output "logdna" {
  value       = module.logging
  description = "Info about LogDNA instance."
}

output "sysdig" {
  value       = module.monitoring
  description = "Info about SysDig instance."
}