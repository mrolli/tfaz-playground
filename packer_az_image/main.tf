# Get current logged in user of the Azure CLI
data "azuread_client_config" "currentLoginUser" {}

# Create a service principal for this service
module "tfbackend_sp" {
  source                   = "git::https://github.unibe.ch/id-unibe-ch/terraform-module-az-service-principal?ref=0.1.0"
  service_principal_name   = "${var.service_display_name} DEV"
  service_principal_owners = [data.azuread_client_config.currentLoginUser.object_id]
}

module "tfbackend" {
  source              = "git::https://github.unibe.ch/id-unibe-ch/terraform-module-az-tfbackend?ref=0.1.0"
  resource_group_name = var.resource_group_name
  # resource_group_name  = "rg-${var.service_name}-terraform-${var.stage}"
  storage_account_name = var.storage_account_name
  # storage_account_name = "st${var.service_name}tf${var.stage}"
  container_name       = "tfstate"
  admin_id             = data.azuread_client_config.currentLoginUser.object_id
  service_principal_id = module.tfbackend_sp.service_principal_id

  tags = var.azproject_tags
}

#
# Create a resource group
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
# resource "azurerm_resource_group" "rg-service" {
#   name     = "rg-${var.service_name}-${var.stage}"
#   location = var.azlocation
#
#   tags = var.azproject_tags
# }

# Create a service principal with role Contributor in current resource group scope
#
# Create an application in Azure Active Directory
# resource "azuread_application" "app-packerimgreg" {
#   display_name     = "${var.azure_application_name}-001"
#   sign_in_audience = "AzureADMyOrg"
#   owners = [
#     data.azuread_client_config.currentLoginUser.object_id
#   ]
# }

# Create a service principal for the application
# resource "azuread_service_principal" "sp-packerimgreg" {
#   client_id = azuread_application.app-packerimgreg.client_id
#   owners = [
#     data.azuread_client_config.currentLoginUser.object_id
#   ]
# }

# Assign the Contributor role to the service principal in the resource group scope
# resource "azurerm_role_assignment" "role-packerimgreg" {
#   scope                = azurerm_resource_group.rg-service.id
#   role_definition_name = "Contributor"
#   # principal_id         = azuread_service_principal.sp-packerimgreg.id
#   principal_id = module.tfbackend_sp.service_principal_id
# }

# Create a compute gallery, formerly known as an shared image gallery
#
# https://learn.microsoft.com/en-us/azure/virtual-machines/azure-compute-gallery
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/shared_image_gallery
# resource "azurerm_shared_image_gallery" "gal-sysimages" {
#   name                = "gal_sysimages_ID_${var.stage}"
#   location            = var.azlocation
#   resource_group_name = azurerm_resource_group.rg-service.name
#   description         = "Image gallery for system images"
#
#   # sharing {
#   #   permission = "Groups"
#   # }
#   #
#   tags = var.azproject_tags
# }

# Within the compute gallery, create an image definition for which packer can
# create and store matching images
#
# https://learn.microsoft.com/en-us/azure/virtual-machines/shared-image-galleries?tabs=azure-cli
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/shared_image
# resource "azurerm_shared_image" "idsys-image" {
#   name                = "ubuntu22-base"
#   description         = "Ubuntu-jammy image"
#   gallery_name        = azurerm_shared_image_gallery.gal-sysimages.name
#   resource_group_name = azurerm_resource_group.rg-service.name
#   location            = var.azlocation
#   os_type             = "Linux"
#   specialized         = false
#   architecture        = "x64"
#   hyper_v_generation  = "V2"
#
#   identifier {
#     publisher = "UniBE-IDSYS"
#     offer     = "0001-ubuntu-jammy-base"
#     sku       = "22_04-lts"
#   }
#
#   tags = var.azproject_tags
# }
