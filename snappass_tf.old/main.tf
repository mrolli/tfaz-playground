locals {
  environment = "dev"
  default_tags = {
    app_name    = var.app_name
    environment = local.environment
    division    = "id"
    subDivision = "sys"
  }
}

# Create a resource group for the application service
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.app_name}-${local.environment}"
  location = var.location
}
