locals {
  environment = "dev"
  default_tags = {
    app_name    = "snappass"
    environment = local.environment
    division    = "id"
    subDivision = "idsys"
    managedBy   = "terraform"
  }
}

# Create a resource group for the application service
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.app_name}-${local.environment}"
  location = var.location
  tags     = local.default_tags
}
