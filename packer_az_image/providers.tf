# Configure the Microsoft Azure Provider
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
provider "azurerm" {
  features {}
  tenant_id                  = var.tenant_id
  subscription_id            = var.subscription_id
  skip_provider_registration = true
}

provider "azuread" {
  tenant_id = var.tenant_id
}

# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_version = ">=1.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.47.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.86.0"
    }
  }
}

