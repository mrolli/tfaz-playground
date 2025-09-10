module "resource_group" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.2.1"

  location = var.location
  name     = local.resource_names.resource_group_name

  tags             = var.tags
  enable_telemetry = var.enable_telemetry
}

module "staticweapp" {
  source  = "Azure/avm-res-web-staticsite/azurerm"
  version = "0.6.2"

  location            = var.location
  name                = local.resource_names.staticwebapp_name
  resource_group_name = module.resource_group.name
  sku_size            = "Free"
  sku_tier            = "Free"
  repository_url      = local.repository_url
  custom_domains      = local.custom_domains

  tags             = var.tags
  enable_telemetry = var.enable_telemetry
}
