# LogDNA

This terraform example creates a LogDNA instance and is bound to the Red Hat Open Shift cluster which has to be passed in by its ID.

## Infrastructure

Main parts provisioned by terraform defined in `main.tf`. Test

1. LogDNA Service Instance
1. LogDNA Service Key
1. Connect LogDNA with OpenShift cluster

## Requirements

| Name      | Version  |
| --------- | -------- |
| terraform | >= v1.0  |

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
| logdna_plan           | Plan for LogDNA                             | `string` | -             | yes      |
| cluster_id            | ID of the Cluster which should be connected | `string` | -             | yes      |

## Outputs

| Name        | Description                                       | Type     |
| ----------- | ------------------------------------------------- | -------- |
| logDNA_url  | Url of the LogDNA instance to reach the dashboard | `string` |
| logDNA_guid | GUID of the instance                              | `string` |
