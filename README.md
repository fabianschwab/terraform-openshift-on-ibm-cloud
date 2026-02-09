# VPC Gen 2 and OpenShift 4.x

This terraform example creates an OpenShift 4.x Cluster on an IBM Cloud VPC GEN2 Infrastructure with logging and monitoring services.

## Infrastructure

Main parts provisioned by terraform defined in `main.tf`.

1. Resource group, to group all created resources together
1. Virtual Private Cloud (VPC) Generation 2
1. Public Gateways to the internet, depending on the number of zones
1. Subnets within the VPC which is connected to the intended Public Gateway. Also depending of the amount of zones defined
1. RedHat OpenShift 4.x Cluster with 3 worker nodes (each: 4Cores, 16GiB Ram, 8Gbps Network Speed, OS Ubuntu 18 64, 100GB Storage)
1. Cloud Object Storage for backing up the cluster registry
1. Security Group Rule to allow incoming network traffic from the VPC load balancers
1. Access Group for easier rights management
1. Access Group Policy to the resource group for all users with certain rights
1. Invites Users and adds them to the access group

## Running the configuration

### Initial Setup

1. Copy the example variables file:

```shell
cp terraform.tfvars.example terraform.tfvars
```

2. Edit `terraform.tfvars` with your IBM Cloud API key and desired configuration

3. Initialize Terraform:

```shell
terraform init
```

4. Review the planned changes:

```shell
terraform plan
```

### Apply Configuration

```shell
terraform apply
```

### Destroy Infrastructure

```shell
terraform destroy
```

**Note:** After updating the provider version, run `terraform init -upgrade` to update the provider plugins.

## Requirements

| Name      | Version |
| --------- | ------- |
| terraform | >= v1.0 |

## Providers

| Name | Version    |
| ---- | ---------- |
| ibm  | ~> v1.88.0 |

## Inputs

| Name                    | Description                                                   | Type           | Default Value              |
| ----------------------- | ------------------------------------------------------------- | -------------- | -------------------------- |
| ibm_region              | Region                                                        | `string`       | `eu-de`                    |
| ibm_zones               | One or more Zones                                             | `list(string)` | `[eu-de-3, eu-de-2]`       |
| ibm_resource_group_name | Resource Group Name                                           | `string`       | `terraform-resource-group` |
| prefix                  | Prefix for the naming convention                              | `string`       | `fs-dev`                   |
| openshift_flavor        | The flavor of the VPC worker node that you want to use        | `string`       | `bx2.4x16`                 |
| openshift_kube_version  | Version of cluster                                            | `string`       | -                          |
| worker_count            | Number of nodes per zone. If single zone minimum are 2 nodes. | `int`          | 1                          |
| cos_plan                | Plan for Cloud Object Storage                                 | `string`       | `standard`                 |
| cos_location            | Location for Cloud Object Storage                             | `string`       | `global`                   |
| enable_user_invite      | If enabled, all users from variable `users` will be invited.  | `bool`         | `false`                    |
| users                   | List of user e-mail addresses                                 | `list(string)` | -                          |
| access_roles_platform   | List of valid platform roles                                  | `list(string)` | `[""Editor"]`              |
| access_roles_services   | List of valid services roles                                  | `list(string)` | `["Manager"]`              |

## Outputs

| Name         | Description                   | Type     |
| ------------ | ----------------------------- | -------- |
| vpc_name     | Generated name of the vpc     | `string` |
| vpc_id       | Unique ID of the vpc          | `string` |
| cluster_name | Generated name of the cluster | `string` |
| cluster_id   | Unique id of the cluster      | `string` |
| cluster_url  | Url of the RHOS dashboard     | `string` |

## References

- Terraform [Provider Registry](https://registry.terraform.io/browse/providers)
- IBM Cloud provider documentation for [terraform](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest) on terraform.io
- IBM Cloud provider documentation for [terraform](https://cloud.ibm.com/docs/ibm-cloud-provider-for-terraform) on cloud.ibm.com
- Git repository IBM [terraform provider](https://github.com/IBM-Cloud/terraform-provider-ibm)
