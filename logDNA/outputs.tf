output "logdna_url" {
  value       = ibm_resource_instance.logdna.dashboard_url
  description = "Url of the LogDNA instance to reach the dashboard"
}

output "logdna_guid" {
  value       = ibm_resource_instance.logdna.guid
  description = "GUID of the instance"
}