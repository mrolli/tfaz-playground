# Configure the Microsoft Azure Provider
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# Configure the Azure Active Directory Provider
#
# https://registry.terraform.io/providers/hashicorp/azuread/latest/docs
provider "azuread" {}
