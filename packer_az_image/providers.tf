# Configure the Microsoft Azure Provider
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
provider "azurerm" {
  features {}
  tenant_id                  = var.tenant_id
  subscription_id            = var.subscription_id
  skip_provider_registration = true
}

# Configure the Azure Active Directory Provider
#
# https://registry.terraform.io/providers/hashicorp/azuread/latest/docs
provider "azuread" {
  tenant_id = var.tenant_id
}

# Configure the Local Provider
#
# https://registry.terraform.io/providers/hashicorp/local/latest/docs
provider "local" {}
