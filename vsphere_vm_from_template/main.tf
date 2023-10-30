# We strongly recommend using the required_providers block to set the
# VMware vSphere Provider source and version being used
terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">=2.5.1"
    }
  }
}

# Configure the VMware vSphere Provider
#
# https://www.terraform.io/docs/providers/vsphere/index.html
provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server
}

data "vsphere_datacenter" "dc" {
  name = "VI IDunibe"
}

# g700v119 (/VI IDunibe/datastore/VALINOR-VR/ValinorVR-FMC/g700v119)
data "vsphere_datastore" "ds-g700v119" {
  name          = "g700v119"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "ds-nfsimages" {
  name          = "NFSImages"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# data "vsphere_compute_cluster" "cluster" {
#   name          = "VALINOR"
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

# data "vsphere_resource_pool" "IDLXDev" {
#   name          = "IDLXDev"
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

data "vsphere_network" "net-zb21-id-dev-10" {
  name          = "ZB21-ID-DEV-10"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "vmtemplate_rocky8_vr" {
  name          = "ID_SYS_rocky8_template_VR"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "vmtemplate_rocky8_ex" {
  name          = "ID_SYS_rocky8_template_EX"
  datacenter_id = data.vsphere_datacenter.dc.id
}
