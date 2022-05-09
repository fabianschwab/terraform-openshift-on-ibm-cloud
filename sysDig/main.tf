# Terraform version with community provider
terraform {
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.41.0"
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

# Creating a service key for Sysdig-Monitor
resource "ibm_resource_key" "sysdig_service_key" {
  name                 = "${var.prefix}-sysdig-service-key"
  role                 = "Manager"
  resource_instance_id = ibm_resource_instance.sysdig.id
}

# Connect Sysdig service with cluster
resource "ibm_ob_monitoring" "connect_monitoring" {
  cluster     = var.cluster_id
  instance_id = ibm_resource_instance.sysdig.guid

  depends_on = [ibm_resource_key.sysdig_service_key]
}
