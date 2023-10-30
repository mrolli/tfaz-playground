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

data "vsphere_virtual_machine" "tpl_rocky8_vr" {
  name          = "ID_SYS_rocky8_template_VR"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "tpl_rocky8_ex" {
  name          = "ID_SYS_rocky8_template_EX"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_folder" "linux_betrieb" {
  path = "VI IDunibe/vm/ID SYSTEMS/Linux_Betrieb"
}

data "vsphere_folder" "opencast-test" {
  path = "${data.vsphere_folder.linux_betrieb.path}/Opencast-test"
}

# Create a new virtual machine from template
#
# https://www.terraform.io/docs/providers/vsphere/r/virtual_machine.html
# https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/virtual_machine#creating-a-virtual-machine-from-a-template
# https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/virtual_machine#cloning-and-customization
resource "vsphere_virtual_machine" "idmrollidev01" {
  name             = "ID_SYS_idmrollidev01"
  resource_pool_id = "resgroup-1653170"
  folder           = data.vsphere_folder.opencast-test.path
  # resource_pool_id = data.vsphere_virtual_machine.tpl_rocky8_vr.resource_pool_id
  guest_id  = data.vsphere_virtual_machine.tpl_rocky8_vr.guest_id
  scsi_type = data.vsphere_virtual_machine.tpl_rocky8_vr.scsi_type
  num_cpus  = 1
  memory    = 1024
  network_interface {
    network_id   = data.vsphere_network.net-zb21-id-dev-10.id
    adapter_type = data.vsphere_virtual_machine.tpl_rocky8_vr.network_interface_types.0
  }
  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.tpl_rocky8_vr.disks.0.size
    thin_provisioned = true # true is the default
  }
  # Clone from template
  # https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/virtual_machine#cloning-and-customization
  clone {
    template_uuid = data.vsphere_virtual_machine.tpl_rocky8_vr.id
    customize {
      linux_options {
        host_name = "idmrolldev01"
        domain    = "test.unibe.ch"
      }
      network_interface {
        ipv4_address = "130.92.10.248"
        ipv4_netmask = 24
      }
      ipv4_gateway = "130.92.10.1"
    }
  }
}
