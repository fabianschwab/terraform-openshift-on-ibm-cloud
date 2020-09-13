# Terraform version with community provider
terraform {
  required_version = ">= 0.13"

  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.11.2"
    }
    # Null Provider for executing shell commands
    null = {
      version = ">= 2.1"
    }
  }
}

# LogDNA
resource "ibm_resource_instance" "logdna" {
  name     = "${var.prefix}-logdna"
  service  = "logdna"
  plan     = var.plan
  location = var.ibm_region

  resource_group_id = var.resource_group_id
}

# Creating a service key for logdna
resource "ibm_resource_key" "logdna-service-key" {
  name                 = "${var.prefix}-logdna-service-key"
  role                 = "Manager"
  resource_instance_id = ibm_resource_instance.logdna.id
}

# Connect logdna service with cluster
resource "null_resource" "connect-logdna-2-cluster" {
  provisioner "local-exec" {
    command = "ibmcloud ob logging config create --cluster ${var.cluster_id} --instance ${ibm_resource_instance.logdna.name}"
  }
}
