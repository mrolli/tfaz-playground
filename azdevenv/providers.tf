# Configure the Microsoft Azure Provider
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
provider "azurerm" {
  features {}
  tenant_id                  = "d400387a-212f-43ea-ac7f-77aa12d7977e" # == UniBE
  subscription_id            = "9671b6ad-4877-4a42-9609-9eaf88283097" # == UniBE - IDSYS - DEV - 021-14
  skip_provider_registration = true
}

# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_version = ">=1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.76.0"
    }
  }
}

