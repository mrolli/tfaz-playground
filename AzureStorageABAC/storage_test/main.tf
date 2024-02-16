provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "rg-demo-storage-test"
  location = "switzerlandnorth"
}
