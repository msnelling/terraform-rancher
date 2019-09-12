provider rancher2 {
  alias     = "bootstrap"
  api_url   = "https://${var.rancher_hostname}.${var.rancher_domain}"
  bootstrap = true
  insecure  = true
}

resource "rancher2_bootstrap" "admin" {
  provider   = "rancher2.bootstrap"
  password   = var.rancher_admin_password
  telemetry  = true
  depends_on = [vsphere_virtual_machine.rancher]
}

provider "rancher2" {
  api_url   = "${rancher2_bootstrap.admin.url}"
  token_key = "${rancher2_bootstrap.admin.token}"
  insecure  = true
}

resource "rancher2_cloud_credential" "vsphere_homelab" {
  name = "homelab"
  vsphere_credential_config {
    vcenter      = var.vsphere_server
    vcenter_port = var.vsphere_port
    username     = var.vsphere_username
    password     = var.vsphere_password
  }
}

resource "rancher2_node_template" "small" {
  name                = "1vCPU-2GiRAM-8GiSSD"
  cloud_credential_id = rancher2_cloud_credential.vsphere_homelab.id
  vsphere_config {
    cpu_count   = 1
    memory_size = 2048
    disk_size   = 8192
    cloudinit   = "https://pastebin.com/raw/ZYK9whBe"
    cfgparam    = ["disk.enableUUID=TRUE"]
    datastore   = var.vsphere_vm_datastore
    network     = [var.vsphere_vm_network, "Storage Network"]
  }
  engine_registry_mirror = ["https://docker-registry.${var.rancher_domain}"]
}

resource "rancher2_node_template" "medium" {
  name                = "2vCPU-4GiRAM-16GiSSD"
  cloud_credential_id = rancher2_cloud_credential.vsphere_homelab.id
  vsphere_config {
    cpu_count   = 2
    memory_size = 4096
    disk_size   = 16384
    cloudinit   = "https://pastebin.com/raw/ZYK9whBe"
    cfgparam    = ["disk.enableUUID=TRUE"]
    datastore   = var.vsphere_vm_datastore
    network     = [var.vsphere_vm_network, "Storage Network"]
  }
  engine_registry_mirror = ["https://docker-registry.${var.rancher_domain}"]
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
    #"guestinfo.cloud-init.config.data"   = base64encode(data.template_file.rancher_cloud_config.rendered)
    #"guestinfo.cloud-init.data.encoding" = "base64"
    "guestinfo.cloud-init.config.data"   = base64gzip(data.template_file.rancher_cloud_config.rendered)
    "guestinfo.cloud-init.data.encoding" = "gzip+base64"
  }

  cdrom {
    datastore_id = data.vsphere_datastore.iso_datastore.id
    path         = var.rancher_iso_path
  }

  network_interface {
    network_id   = data.vsphere_network.vm.id
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

data "template_file" "rancher_cloud_config" {
  template = file("${path.module}/files/rancher_cloud_config.yml.tpl")

  vars = {
    rancher_hostname = var.rancher_hostname
    rancher_domain   = var.rancher_domain
    dns_servers      = join(",", var.dns_servers)
  }
}
