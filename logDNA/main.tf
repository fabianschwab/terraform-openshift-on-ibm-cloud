# Terraform version with community provider
terraform {
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.41.0"
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

# Creating a service key for LogDNA
resource "ibm_resource_key" "logdna_service_key" {
  name                 = "${var.prefix}-logdna-service-key"
  role                 = "Manager"
  resource_instance_id = ibm_resource_instance.logdna.id

}

# Connect logdna service with cluster
resource "ibm_ob_logging" "connect_logging" {
  cluster     = var.cluster_id
  instance_id = ibm_resource_instance.logdna.guid

  depends_on = [ibm_resource_key.logdna_service_key]
}
