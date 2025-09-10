data "azurerm_client_config" "current" {}

data "github_repository" "staticwebapp" {
  name = var.repository_name
}

module "regions" {
  source           = "Azure/avm-utl-regions/azurerm"
  version          = "0.7.0"
  enable_telemetry = var.enable_telemetry
}
