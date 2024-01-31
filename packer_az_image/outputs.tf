output "tenant_id" {
  value = var.tenant_id
}

output "subscription_id" {
  value = var.subscription_id
}

output "client_id" {
  value = module.service_principal.service_principal_id
}

output "client_secret" {
  value     = module.service_principal.password
  sensitive = true
}

output "location" {
  value = var.location
}

output "project_tags" {
  value = var.project_tags
}
