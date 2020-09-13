output "sysdig_url" {
  value       = ibm_resource_instance.sysdig.dashboard_url
  description = "Url of the SysDig instance to reach the dashboard"
}

output "sysdig_guid" {
  value       = ibm_resource_instance.sysdig.guid
  description = "GUID of the instance"
}