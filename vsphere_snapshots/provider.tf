# Configure the VMware vSphere Provider
#
# https://www.terraform.io/docs/providers/vsphere/index.html
provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server
}

# We strongly recommend using the required_providers block to set the
# VMware vSphere Provider source and version being used
terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">=2.6.1"
    }
  }
}

