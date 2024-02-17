# See https://developer.hashicorp.com/packer/guides/packer-on-cicd/pipelineing-builds
source "virtualbox-iso" "step_1" {
  boot_command     = ["<esc><wait>", "<esc><wait>", "<enter><wait>",
                      "/install/vmlinuz<wait>", " initrd=/install/initrd.gz",
                      " auto-install/enable=true", " debconf/priority=critical",
                      " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ubuntu_preseed.cfg<wait>",
                      " -- <wait>", "<enter><wait>"]
  disk_size        = "20480"
  guest_os_type    = "Ubuntu_64"
  http_directory   = "./http"
  iso_checksum     = "sha256:ababb88a492e08759fddcf4f05e5ccc58ec9d47fa37550d63931d0a5fa4f7388"
  iso_url          = "http://old-releases.ubuntu.com/releases/14.04.1/ubuntu-14.04-server-amd64.iso"
  shutdown_command = "echo 'vagrant' | sudo -S shutdown -P now"
  ssh_password     = "vagrant"
  ssh_username     = "vagrant"
  ssh_port         = 22
  vm_name          = "vbox-example"
}

source "virtualbox-ovf" "step_2" {
  shutdown_command = "echo 'vagrant' | sudo -S shutdown -P now"
  source_path      = "output-virtualbox-iso/vbox-example.ovf"
  ssh_password     = "vagrant"
  ssh_port         = 22
  ssh_username     = "vagrant"
  vm_name          = "virtualbox-example-ovf"
}

build {
  sources = ["source.virtualbox-ovf.step_2"]

  provisioner "shell" {
    inline = ["echo secondary provisioning"]
  }
}



build {
  sources = ["source.virtualbox-iso.step_1"]


  provisioner "shell" {
    inline = ["echo initial provisioning"]
  }
  post-processor "manifest" {
    output = "stage-1-manifest.json"
  }
}
