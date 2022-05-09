##########
# General
##########

variable "ibmcloud_api_key" {
  type        = string
  description = "IBM Cloud API Key."
  sensitive   = true
}

variable "prefix" {
  type        = string
  description = "Prefix for all resources which are created. Must begin with a letter."
  default     = "fs-dev"
}

variable "ibm_region" {
  type        = string
  description = "Region and zone the resources should be created in."
  default     = "eu-de"
}

variable "ibm_zones" {
  type        = list(string)
  description = "Zones the resources should be created in."
  default     = ["eu-de-3", "eu-de-2"]
}

###################################
# IAM - Identity Access Management
###################################

variable "resource_group" {
  type        = string
  description = "Name of resource group to provision resources."
  default     = "terraform-resource-group"
}

variable "enable_user_invite" {
  type        = bool
  description = "If enabled all users from variable `users` will be invited."
  default     = false
}
variable "users" {
  type        = list(string)
  description = "E-Mail addresses of all users, which should be invited to this project. When enabled."
  default     = ["example@email.com"]
}

variable "access_roles_platform" {
  type        = list(string)
  description = "Platform access roles (`viewer`, `operator`, `editor`, `administrator`) for the resouce group."
  default     = ["Editor"]
}

variable "access_roles_services" {
  type        = list(string)
  description = "Service access roles (`reader`, `writer`, `manager`) for the resouce group."
  default     = ["Manager"]
}

############
# Openshift
############

variable "openshift_flavor" {
  type        = string
  description = "The flavor of the VPC worker node that you want to use. Flavor overview list with '<zone_name>'."
  default     = "bx2.4x16"
}

variable "openshift_kube_version" {
  type        = string
  description = "Version of cluster. For a list run 'ibmcloud ks versions'."
}

variable "worker_count" {
  type        = number
  description = "Number of worker nodes."
  default     = 3
}

variable "cos_plan" {
  type        = string
  description = "Plan for Cloud Object Storage."
  default     = "standard"
}

variable "cos_location" {
  type        = string
  description = "Location for Cloud Object Storage."
  default     = "global"
}

#########################
# Logging and Monitoring
#########################

variable "enable_logdna" {
  type        = bool
  description = "If set to true, logDNA instance will be created and connected to the cluster."
  default     = true
}

variable "logdna_plan" {
  type        = string
  description = "Plan for LogDNA (e.g. lite, 7-day, ...)."
  default     = "lite"
}

variable "enable_sysdig" {
  type        = bool
  description = "If set to true, Sysdig instance will be created and connected to the cluster."
  default     = true
}

variable "sysdig_plan" {
  type        = string
  description = "Plan for Sysdig (e.g. lite, graduated-tier, ...)."
  default     = "lite"
}
