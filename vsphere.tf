provider "vsphere" {
  vsphere_server       = var.vsphere_server
  user                 = var.vsphere_username
  password             = var.vsphere_password
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "vm_datastore" {
  name          = var.rancher_vm_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "iso_datastore" {
  name          = var.rancher_iso_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {}

data "vsphere_network" "rancher_vm" {
  name          = var.rancher_vm_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "rancher" {
  name             = "Rancher"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.vm_datastore.id

  num_cpus             = 1
  num_cores_per_socket = 1
  memory               = 4096
  guest_id             = "other4xLinux64Guest"
  alternate_guest_name = "RancherOS"
  firmware             = "bios"
  scsi_type            = "pvscsi"

  extra_config = {
    "guestinfo.cloud-init.config.data"   = base64encode(data.template_file.cloud_config.rendered)
    "guestinfo.cloud-init.data.encoding" = "base64"
  }

  cdrom {
    datastore_id = data.vsphere_datastore.iso_datastore.id
    path         = var.rancher_iso_path
  }

  network_interface {
    network_id   = data.vsphere_network.rancher_vm.id
    adapter_type = "vmxnet3"
  }

  disk {
    label            = "os_disk"
    size             = 8
    path             = "OS.vmdk"
    thin_provisioned = true
    eagerly_scrub    = false
  }
}

data "template_file" "cloud_config" {
  template = file("${path.module}/files/cloud-config.yml.tpl")

  vars = {
    rancher_hostname = var.rancher_hostname
    rancher_domain   = var.rancher_domain
    dns_servers      = join(",", var.rancher_dns_servers)
  }
}
