# Get current logged in user of the Azure CLI
data "azuread_client_config" "currentLoginUser" {}

# Create a service principal for this service
module "service_principal" {
  source                   = "git::https://github.unibe.ch/id-unibe-ch/terraform-module-az-service-principal?ref=0.1.0"
  service_principal_name   = "${var.service_display_name} DEV"
  service_principal_owners = [data.azuread_client_config.currentLoginUser.object_id]
}

module "tfbackend" {
  source               = "git::https://github.unibe.ch/id-unibe-ch/terraform-module-az-tfbackend?ref=0.1.0"
  resource_group_name  = "rg-${var.service_name}-terraform-${var.stage}"
  storage_account_name = "st${var.service_name}tf${substr(var.stage, 0, 1)}"
  container_name       = "tfstate"
  admin_id             = data.azuread_client_config.currentLoginUser.object_id
  service_principal_id = module.service_principal.service_principal_id

  tags = var.project_tags
}

#
# Create a resource group
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
resource "azurerm_resource_group" "rg-service" {
  name     = "rg-${var.service_name}-${var.stage}"
  location = var.location

  tags = var.project_tags
}

# Create a service principal with role Contributor in current resource group scope
#
# Create an application in Azure Active Directory
# resource "azuread_application" "app-packerimgreg" {
#   display_name     = "${var.service_display_name}-${var.stage}"
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
resource "azurerm_role_assignment" "role-sp-to-rg-service" {
  scope                = azurerm_resource_group.rg-service.id
  role_definition_name = "Contributor"
  principal_id         = module.service_principal.service_principal_id
  # principal_id         = azuread_service_principal.sp-packerimgreg.id
}

# Create a compute gallery, formerly known as an shared image gallery
#
# https://learn.microsoft.com/en-us/azure/virtual-machines/azure-compute-gallery
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/shared_image_gallery
resource "azurerm_shared_image_gallery" "gal-sysimages" {
  name                = "gal_sysimages_ID_${var.stage}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-service.name
  description         = "Image gallery for system images"

  # sharing {
  #   permission = "Groups"
  # }
  #
  tags = var.project_tags
}

# Within the compute gallery, create an image definition for which packer can
# create and store matching images
#
# https://learn.microsoft.com/en-us/azure/virtual-machines/shared-image-galleries?tabs=azure-cli
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/shared_image
resource "azurerm_shared_image" "sysimg-ubuntu2204-base" {
  name                = "ubuntu22-base"
  description         = "Ubuntu-jammy base image"
  gallery_name        = azurerm_shared_image_gallery.gal-sysimages.name
  resource_group_name = azurerm_resource_group.rg-service.name
  location            = var.location
  os_type             = "Linux"
  specialized         = false
  architecture        = "x64"
  hyper_v_generation  = "V2"

  identifier {
    publisher = "UniBE-IDSYS"
    offer     = "0001-ubuntu-jammy-base"
    sku       = "22_04-lts-gen2"
  }

  tags = var.project_tags
}

resource "local_sensitive_file" "pkrvars" {
  filename = "${path.module}/variables.auto.pkrvars.json"
  content = jsonencode({
    subscription_id = var.subscription_id
    resource_group  = azurerm_resource_group.rg-service.name
    image_gallery   = azurerm_shared_image_gallery.gal-sysimages.name
    client_id       = module.service_principal.service_principal_id
    client_secret   = module.service_principal.password
    region          = var.location
    project_tags    = var.project_tags
  })
}
