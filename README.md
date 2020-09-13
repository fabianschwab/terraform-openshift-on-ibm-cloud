# VPC Gen 2 and OpenShift 4.3

This terraform example creates an OpenShift 4.3 Cluster on an IBM Cloud VPC GEN2 Infrastructure with logging and monitoring services.

## Infrastructure

Main parts provisioned by terraform defined in `main.tf`. Used modules `logDNA` and `sysDig`.

1. Virtual Private Cloud (VPC) Generation 2
1. Public Gateways to the internet, depending on the number of zones.
1. Subnets within the VPC which is connected to the intended Public Gateway. Also depending of the amount of zones defined.
1. RedHat OpenShift 4.3 Cluster with 3 worker nodes (each: 4Cores, 16GB Ram, 8Gbps Network Speed, OS Ubuntu 18 64, 100GB Storage)
1. Cloud Object Storage for backing up the cluster registry
1. Security Group Rule to allow incoming network traffic from the VPC load balancers
1. Optional via Modules
   1. LogDNA Service Instance
   1. LogDNA Service Key
   1. Connect LogDNA with OpenShift cluster
   1. SysDig Service Instance
   1. SysDig Service Key
   1. Connect SysDig with OpenShift cluster

## Running the configuration

```shell
terraform init
terraform plan
```

For apply phase

```shell
terraform apply
```

For destroy phase

```shell
terraform destroy
```

## Requirements

| Name      | Version  |
| --------- | -------- |
| terraform | >= v0.13 |

## Providers

| Name | Version    |
| ---- | ---------- |
| ibm  | >= v1.11.2 |

## Inputs

| Name                    | Description                                            | Type     | Default Value        | Required |
| ----------------------- | ------------------------------------------------------ | -------- | -------------------- | -------- |
| ibmcloud_api_key        | An API key for IBM Cloud services.                     | `string` | -                    | yes      |
| ibm_region              | Region                                                 | `string` | `eu-de`              | yes      |
| ibm_zones               | One or more Zones                                      | `list`   | `[eu-de-3, eu-de-2]` | yes      |
| ibm_resource_group_name | Resource Group Name                                    | `string` | -                    | yes      |
| prefix                  | Prefix for the naming convention                       | `string` | `fs-dev`             | no       |
| ibm_vpc_generation      | Virtual Private Cloud Gen 2                            | `int`    | 2                    | yes      |
| openshift_flavor        | The flavor of the VPC worker node that you want to use | `string` | `bx2.4x16`           | yes      |
| openshift_kube_version  | Version of cluster                                     | `string` | `4.3.31_openshift`   | yes      |
| worker_count            | Number of worker nodes                                 | `int`    | 2                    | no       |
| cos_plan                | Plan for Cloud Object Storage                          | `string` | `standard`           | yes      |
| cos_location            | Location for Cloud Object Storage                      | `string` | `global`             | no       |
| enable_logdna           | LogDNA Service                                         | `bool`   | `false`              | no       |
| logdna_plan             | Plan for LogDNA                                        | `string` | -                    | no       |
| enable_sysdig           | Sysdig Service                                         | `bool`   | `false`              | no       |
| sysdig_plan             | lan for Sysdig                                         | `string` | -                    | no       |

## Outputs

| Name         | Description                   | Type     |
| ------------ | ----------------------------- | -------- |
| vpc_name     | Generated name of the vpc     | `string` |
| vpc_id       | Unique ID of the vpc          | `string` |
| cluster_name | Generated name of the cluster | `string` |
| cluster_id   | Unique id of the cluster      | `string` |
| cluster_url  | Url of the RHOS dashboard     | `string` |
| logdna       | Url, ID of the instance       | `object` |
| sysdig       | Url, ID of the instance       | `object` |

## References

- Terraform [Community Provider](https://www.terraform.io/docs/providers/type/community-index.html)
- IBM Cloud provider documentation for [terraform](https://cloud.ibm.com/docs/terraform?topic=terraform-index-of-terraform-resources-and-data-sources)
- Git repository IBM [terraform provider](https://github.com/IBM-Cloud/terraform-provider-ibm)
