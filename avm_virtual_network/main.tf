locals {
  environment = "dev"
  default_tags = {
    environment = local.environment
    division    = "id"
    subDivision = "idci"
    managedBy   = "terraform"
  }
  rg_name   = format("rg-%s-%s", var.service_name, local.environment)
  vnet_name = format("vnet-%s-%s", var.service_name, var.location)
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.2"
  suffix  = [format("%s-%s", var.service_name, local.environment)]
}

module "avm-res-resources-resourcegroup" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.2.1"

  name             = module.naming.resource_group.name_unique
  location         = var.location
  tags             = local.default_tags
  enable_telemetry = false
}

module "avm-res-network-virtualnetwork" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.8.1"

  name                = module.naming.virtual_network.name_unique
  resource_group_name = module.avm-res-resources-resourcegroup.name
  address_space       = ["10.5.0.0/16"]
  location            = module.avm-res-resources-resourcegroup.resource.location

  tags             = local.default_tags
  enable_telemetry = false
}
