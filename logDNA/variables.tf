variable "prefix" {
  type        = string
  description = "Prefix for all resources which are created. Must begin with a letter."
}

variable "ibm_region" {
  type        = string
  description = "Region and zone the resources should be created in."
}

variable "resource_group_id" {
  type        = string
  description = "ID of resource group to provision resources."
}

variable "plan" {
  type        = string
  description = "Plan for LogDNA (e.g. lite, 7-day, ...)"
}

variable "cluster_id" {
  type        = string
  description = "ID of the cluster which should be connected to logging"
}
