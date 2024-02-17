terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">= 2.0"
    }
  }
}

provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = false
}

data "vsphere_datacenter" "dc" {}

resource "vsphere_folder" "parent" {
  path          = "/VI UniBE"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}
