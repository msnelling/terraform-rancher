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
    datastore   = var.rancher_vm_datastore
    network     = [var.rancher_vm_network]
  }
}

resource "rancher2_node_template" "medium" {
  name                = "2vCPU-4GiRAM-16GiSSD"
  cloud_credential_id = rancher2_cloud_credential.vsphere_homelab.id
  vsphere_config {
    cpu_count   = 1
    memory_size = 4096
    disk_size   = 16384
    cloudinit   = "https://pastebin.com/raw/ZYK9whBe"
    cfgparam    = ["disk.enableUUID=TRUE"]
    datastore   = var.rancher_vm_datastore
    network     = [var.rancher_vm_network]
  }
}

resource "rancher2_cluster" "test" {
  name = "test"
  rke_config {
    network {
      plugin = "canal"
    }
  }
}

resource "rancher2_node_pool" "master" {
  cluster_id       = rancher2_cluster.test.id
  name             = "master"
  hostname_prefix  = "test-master-"
  node_template_id = rancher2_node_template.small.id
  quantity         = 1
  control_plane    = true
  etcd             = true
  worker           = true
}

resource "rancher2_node_pool" "minion" {
  cluster_id       = rancher2_cluster.test.id
  name             = "minion"
  hostname_prefix  = "test-minion-"
  node_template_id = rancher2_node_template.medium.id
  quantity         = 1
  control_plane    = false
  etcd             = false
  worker           = true
}