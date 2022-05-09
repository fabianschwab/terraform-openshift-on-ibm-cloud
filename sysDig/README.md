# SysDig

This terraform example creates a SysDig instance and is bound to the Red Hat Open Shift cluster which has to be passed in by its ID.

## Infrastructure

Main parts provisioned by terraform defined in `main.tf`.

1. SysDig Service Instance
1. SysDig Service Key
1. Connect SysDig with OpenShift cluster

## Requirements

| Name      | Version |
| --------- | ------- |
| terraform | >= v1.0 |

## Providers

| Name | Version    |
| ---- | ---------- |
| ibm  | >= v1.41.0 |

## Inputs

| Name                  | Description                                 | Type     | Default Value | Required |
| --------------------- | ------------------------------------------- | -------- | ------------- | -------- |
| prefix                | Prefix for the naming convention            | `string` | -             | yes      |
| ibm_region            | Region                                      | `string` | -             | yes      |
| ibm_resource_group_id | Resource Group ID                           | `string` | -             | yes      |
| sysdig_plan           | Plan for SysDig                             | `string` | -             | yes      |
| cluster_id            | ID of the Cluster which should be connected | `string` | -             | yes      |

## Outputs

| Name        | Description                                       | Type     |
| ----------- | ------------------------------------------------- | -------- |
| sysdig_url  | Url of the SysDig instance to reach the dashboard | `string` |
| sysdig_guid | GUID of the instance                              | `string` |
