# Create a resource group
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
resource "azurerm_resource_group" "rg-packerimgreg" {
  name     = var.azure_resource_group
  location = var.azure_region

  tags = var.azure_tags
}

# Create a compute gallery, formerly known as an shared image gallery
#
# https://learn.microsoft.com/en-us/azure/virtual-machines/azure-compute-gallery
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/shared_image_gallery
resource "azurerm_shared_image_gallery" "idsys-image-gallery" {
  name                = "gal_idsys_images_dev_001"
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.rg-packerimgreg.name
  description         = "Image gallery for ${var.azure_image_gallery_name}"

  # sharing {
  #   permission = "Groups"
  # }
  #
  tags = var.azure_tags
}

# Within the compute gallery, create an image definition for which packer can
# create and store matching images
#
# https://learn.microsoft.com/en-us/azure/virtual-machines/shared-image-galleries?tabs=azure-cli
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/shared_image
resource "azurerm_shared_image" "idsys-image" {
  name                = "ubuntu22-base"
  description         = "Ubuntu-jammy image for ${var.azure_image_gallery_name}"
  gallery_name        = azurerm_shared_image_gallery.idsys-image-gallery.name
  resource_group_name = azurerm_resource_group.rg-packerimgreg.name
  location            = var.azure_region
  os_type             = "Linux"
  specialized         = false
  architecture        = "x64"
  hyper_v_generation  = "V2"

  identifier {
    publisher = "UniBE-IDSYS"
    offer     = "0001-ubuntu-jammy-base"
    sku       = "22_04-lts"
  }

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
