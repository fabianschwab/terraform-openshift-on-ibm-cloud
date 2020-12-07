# Terraform version with community provider
terraform {
  required_version = ">= 0.13"

  required_providers {
    ibm = {
      source  = "ibm-cloud/ibm"
      version = ">= 1.16.1"
    }
    # Null Provider for executing shell commands
    null = {
      version = ">= 2.1"
    }
  }
}

# Sysdig-Monitor
resource "ibm_resource_instance" "sysdig" {
  name     = "${var.prefix}-sysdig"
  service  = "sysdig-monitor"
  plan     = var.plan
  location = var.ibm_region

  resource_group_id = var.resource_group_id
}

# Creating a service key for Sysdig
resource "ibm_resource_key" "sysdig-service-key" {
  name                 = "${var.prefix}-sysdig-service-key"
  role                 = "Manager"
  resource_instance_id = ibm_resource_instance.sysdig.id
}

# Connect Sysdig service with cluster
resource "null_resource" "connect-sysdig-2-cluster" {
  provisioner "local-exec" {
    command = "ibmcloud ob monitoring config create --cluster ${var.cluster_id} --instance ${ibm_resource_instance.sysdig.name}"
  }
  # TODO: Is the destroy needed or is it destroyed by default.
  # provisioner "local-exec" {
  #   when    = "destroy"
  #   command = "echo 'Destroy-time provisioner'"
  # }
}
