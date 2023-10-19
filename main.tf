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

# Create a network security group
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group
resource "azurerm_network_security_group" "tf-dev-secgroup" {
  name                = "unibe-idsys-dev-tf-testnetwork-secgroup"
  resource_group_name = azurerm_resource_group.tf-testgroup.name
  location            = azurerm_resource_group.tf-testgroup.location

  tags = {
    environment = "dev"
    division    = "id"
    subDivision = "sys"
  }
}

# Create security rule to allow SSH access from the ID network
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule
resource "azurerm_network_security_rule" "tf-dev-secrule-ssh" {
  name                        = "unibe-idsys-dev-tf-testnetwork-secrule-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "130.92.8.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.tf-testgroup.name
  network_security_group_name = azurerm_network_security_group.tf-dev-secgroup.name
}

# Associate the SSH security rule with the subnet previously created
# This is required to allow SSH access to the VMs in the subnet.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association
resource "azurerm_subnet_network_security_group_association" "tf-dev-secgroup-subnet3-assoc" {
  subnet_id                 = azurerm_subnet.tf-subnet-3.id
  network_security_group_id = azurerm_network_security_group.tf-dev-secgroup.id
}
