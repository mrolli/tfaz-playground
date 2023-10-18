# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.76.0"
    }
  }
}

# Configure the Microsoft Azure Provider
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
provider "azurerm" {
  features {}
}

# Create a resource group
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
resource "azurerm_resource_group" "tf-testgroup" {
  name     = "unibe-idsys-dev-tf-testgroup"
  location = "switzerlandnorth"

  tags = {
    environment = "dev"
    division    = "id"
    subDivision = "sys"
  }
}

# Create a virtual network
# For more flexibility, we do not define subnets inline but as separate resources.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
resource "azurerm_virtual_network" "tf-testnetwork" {
  name                = "unibe-idsys-dev-tf-testnetwork"
  resource_group_name = azurerm_resource_group.tf-testgroup.name
  location            = azurerm_resource_group.tf-testgroup.location
  address_space       = ["10.123.0.0/16"]

  tags = {
    environment = "dev"
    division    = "id"
    subDivision = "sys"
  }
}

# Create a subnet
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet
resource "azurerm_subnet" "tf-subnet-3" {
  name                 = "unibe-idsys-dev-tf-testnetwork-subnet-3"
  resource_group_name  = azurerm_resource_group.tf-testgroup.name
  virtual_network_name = azurerm_virtual_network.tf-testnetwork.name
  address_prefixes     = ["10.123.3.0/24"]
}
