output "resource_uri" {
  value = module.staticweapp.resource_uri
}

output "domain" {
  value = module.staticweapp.domains
}

output "api_key" {
  value     = module.staticweapp.api_key
  sensitive = true
}
