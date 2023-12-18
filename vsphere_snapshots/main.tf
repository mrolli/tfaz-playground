locals {
  opencast_test_folder = "/VI IDunibe/vm/ID SYSTEMS/Linux_Betrieb/Opencast-test"
}

data "vsphere_datacenter" "dc" {
  name = "VI IDunibe"
}

data "vsphere_virtual_machine" "ocadmintest01" {
  name = "${local.opencast_test_folder}/ID_SYS_ocadmintest01"
}

# resource "vsphere_virtual_machine_snapshot" "ocadmintest01_snapshot" {
#   virtual_machine_uuid = data.vsphere_virtual_machine.ocadmintest01.id
#   snapshot_name        = "VM Snapshot ocadmintest01"
#   description          = "Snapshot taken by Terraform before maintenance"
#   memory               = false
#   quiesce              = true
#   remove_children      = false
#   consolidate          = true
# }
