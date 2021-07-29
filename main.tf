# Terraform version with community provider
terraform {
  required_version = ">= 0.14"

  required_providers {
    ibm = {
      source  = "ibm-cloud/ibm"
      version = ">= 1.28.0"
    }
  }
}

# Region to provision and generation of the Virtual Private Cloud
provider "ibm" {
  region           = var.ibm_region
  ibmcloud_api_key = var.ibmcloud_api_key
}

###################################
# IAM - Identity Access Management
###################################


# Create resource group where all resources are going to be provisioned
resource "ibm_resource_group" "resource_group" {
  name = var.resource_group
}

# Create access group for easier rights management
resource "ibm_iam_access_group" "access_group" {
  name = "${var.prefix}-access-group"
}

# Create a policy for the access group to that all users can see the resource group
resource "ibm_iam_access_group_policy" "access_group_policy" {
  access_group_id = ibm_iam_access_group.access_group.id
  roles           = var.access_roles

  resources {
    resource_type = "resource-group"
    resource      = ibm_resource_group.resource_group.id
  }
}

# Invite all users and assign them to the access group
resource "ibm_iam_user_invite" "invite_user" {
  users         = var.users
  access_groups = [ibm_iam_access_group.access_group.id]
}

#################
# Infrastructure
#################

# Virtual Private Cloud
resource "ibm_is_vpc" "vpc" {
  name = "${var.prefix}-vpc-gen2"

  resource_group = ibm_resource_group.resource_group.id
}

# Public Gateways to access the internet
resource "ibm_is_public_gateway" "public_gateway" {
  for_each = toset(var.ibm_zones)

  name           = "${var.prefix}-public-gateway-${each.value}"
  vpc            = ibm_is_vpc.vpc.id
  zone           = each.value
  resource_group = ibm_resource_group.resource_group.id
}

# Subnets within the VPC. Also attaching the public gateway.
resource "ibm_is_subnet" "subnet" {
  for_each = toset(var.ibm_zones)

  name = "${var.prefix}-subnet-${each.value}"
  vpc  = ibm_is_vpc.vpc.id
  zone = each.value

  resource_group           = ibm_resource_group.resource_group.id
  total_ipv4_address_count = 256

  public_gateway = ibm_is_public_gateway.public_gateway[each.value].id
}

# Regrab data after all dependencies were executed in order to get the subnets for cluster creating
data "ibm_is_vpc" "vpc_data" {
  name = ibm_is_vpc.vpc.name

  depends_on = [
    ibm_is_vpc.vpc,
    ibm_is_subnet.subnet,
    ibm_is_public_gateway.public_gateway
  ]
}

# Openshift multizone cluster on VPC
resource "ibm_container_vpc_cluster" "cluster" {
  flavor = var.openshift_flavor
  name   = "${var.prefix}-cluster"
  vpc_id = ibm_is_vpc.vpc.id

  depends_on = [
    ibm_is_vpc.vpc,
    ibm_is_subnet.subnet,
    ibm_is_public_gateway.public_gateway,
    data.ibm_is_vpc.vpc_data
  ]

  dynamic "zones" {
    for_each = data.ibm_is_vpc.vpc_data.subnets
    content {
      name      = zones.value.zone
      subnet_id = zones.value.id
    }
  }

  # Required for Gen2 VPC with Openshift to back up Openshift registry
  cos_instance_crn = ibm_resource_instance.cos_instance.crn

  resource_group_id = ibm_resource_group.resource_group.id
  kube_version      = var.openshift_kube_version
  worker_count      = var.worker_count
}

# Cloud Object Storage for Openshift Cluster
resource "ibm_resource_instance" "cos_instance" {
  name     = "${var.prefix}-cos"
  service  = "cloud-object-storage"
  plan     = var.cos_plan
  location = var.cos_location

  resource_group_id = ibm_resource_group.resource_group.id
}

# Gen 2 VPC denies all incoming traffic by default to the worker nodes.
# Therefore ports 30000-32767 must be bound to the default security group, which is created when the VPC is created.
resource "ibm_is_security_group_rule" "default_security_group" {
  group     = ibm_is_vpc.vpc.default_security_group
  direction = "inbound"
  tcp {
    port_min = 30000
    port_max = 32767
  }
}

#########################
# Logging and Monitoring
#########################

module "logging" {
  # When logging enabled, module is executed
  count = var.enable_logdna == true ? 1 : 0

  # Module ./logDNA/main.tf
  source = "./logDNA"

  # Input variables
  prefix            = var.prefix
  ibm_region        = var.ibm_region
  resource_group_id = ibm_resource_group.resource_group.id
  plan              = var.logdna_plan
  cluster_id        = ibm_container_vpc_cluster.cluster.id
}

module "monitoring" {
  # When logging enabled, module is executed
  count = var.enable_sysdig == true ? 1 : 0

  # Module ./sysDig/main.tf
  source = "./sysDig"

  # Input variables
  prefix            = var.prefix
  ibm_region        = var.ibm_region
  resource_group_id = ibm_resource_group.resource_group.id
  plan              = var.sysdig_plan
  cluster_id        = ibm_container_vpc_cluster.cluster.id
}
