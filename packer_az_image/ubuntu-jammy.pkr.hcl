packer {
  required_version = ">= 1.10.0"
  required_plugins {
    virtualbox = {
      version = "~> 1"
      source  = "github.com/hashicorp/virtualbox"
    }
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}

locals {
  timestamp  = regex_replace(timestamp(), "[- TZ:]", "")
  image_name = "${var.prefix}-ubuntu22-${local.timestamp}"
}


source "azure-arm" "ubuntu-jammy-base" {
  os_type                   = "Linux"
  build_resource_group_name = var.az_resource_group
  vm_size                   = "Standard_D2d_v5"

  # Source image
  image_publisher = "Canonical"
  image_offer     = "0001-com-ubuntu-server-jammy"
  image_sku       = "22_04-lts-gen2"
  image_version   = "latest"

  # Destination image
  managed_image_name                = local.image_name
  managed_image_resource_group_name = var.az_resource_group
    shared_image_gallery_destination {
    subscription         = var.az_subscription_id
    resource_group       = var.az_resource_group
    gallery_name         = var.az_image_gallery
    image_name           = "ubuntu22-base"
    image_version        = formatdate("YYYY.MMDD.hhmm", timestamp())
    replication_regions  = [var.az_region]
    storage_account_type = "Standard_LRS"
  }


  azure_tags = {
    division       = var.division
    subDivision    = var.subDivision
    owner          = var.owner
    build-time     = local.timestamp
    ubuntu-version = "22.04"
  }
}

build {
  sources = [
    "source.azure-arm.ubuntu-jammy-base",
  ]

  provisioner "shell" {
    inline = ["echo 'Wait for cloud-init to finish' && /usr/bin/cloud-init status --wait"]
  }

  provisioner "shell" {
    script          = "${path.root}/scripts/update.sh"
    execute_command = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
  }

  provisioner "shell" {
    inline = [
      "sudo ufw enable >/dev/null",
      "sudo ufw allow 22 >/dev/null"
    ]
  }

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline          = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    inline_shebang  = "/bin/sh -x"
  }
}
