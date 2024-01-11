# Create a resource group
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
resource "azurerm_resource_group" "rg-packerimgreg" {
  name     = var.azure_resource_group
  location = var.azure_region

  tags = var.azure_tags
}

# data "azuread_client_config" "current" {}

# Create a service principal with role Contributor in current subscription scope
#
# resource "azurerm_azuread_service_principal" "service_principal" {
#   application_id =
# }

# Create an application in Azure Active Directory
# resource "azuread_application" "app-packerimgreg" {
#   display_name     = "${var.azure_application_name}-001"
#   sign_in_audience = "AzureADMyOrg"
#   owners = [
#     data.azuread_client_config.current.object_id
#   ]
# }
#
# Create a service principal for the application
# resource "azuread_service_principal" "sp-packerimgreg" {
#   client_id = azuread_application.app-packerimgreg.client_id
#   owners = [
#     data.azuread_client_config.current.object_id
#   ]
# }
