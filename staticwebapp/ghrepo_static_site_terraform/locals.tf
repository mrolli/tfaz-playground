# Calculate resource names
locals {
  name_replacements = {
    workload       = var.resource_name_workload
    environment    = var.resource_name_environment
    location       = var.location
    location_short = var.resource_name_location_short == "" ? module.regions.regions_by_name[var.location].geo_code : var.resource_name_location_short
  }

  resource_names = { for key, value in var.resource_name_templates : key => templatestring(value, local.name_replacements) }
}

locals {
  api_token_var = "AZURE_STATIC_WEB_APPS_API_TOKEN"

  repository_url = "https://github.com/${var.github_organisation}/${var.repository_name}"

  custom_domains = var.custom_domain != null ? {
    custom_domain = {
      domain_name = var.custom_domain
    }
  } : {}
}
