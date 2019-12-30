resource rancher2_bootstrap admin {
  provider = rancher2.bootstrap

  # BEGIN Comment out this line if starting from scratch
  #current_password = var.rancher_admin_password
  # END

  password   = var.rancher_admin_password
  telemetry  = true
  depends_on = [null_resource.wait_for_rancher]
}

resource rancher2_cloud_credential vsphere_homelab {
  name = "homelab"
  vsphere_credential_config {
    vcenter      = var.vsphere_server
    vcenter_port = var.vsphere_port
    username     = var.vsphere_username
    password     = var.vsphere_password
  }
}

resource rancher2_node_template small {
  name                = "1vCPU-2GiRAM-8GiSSD"
  cloud_credential_id = rancher2_cloud_credential.vsphere_homelab.id

  vsphere_config {
    cpu_count   = 1
    memory_size = 2048
    disk_size   = 8192
    cloudinit   = "https://pastebin.com/raw/ZYK9whBe"
    cfgparam    = ["disk.enableUUID=TRUE"]
    datastore   = var.vsphere_vm_datastore
    network     = [var.vsphere_vm_network]
    folder      = vsphere_folder.folder.path
  }

  engine_registry_mirror = ["https://${var.docker_registry}"]
}

resource rancher2_node_template medium {
  name                = "2vCPU-4GiRAM-16GiSSD"
  cloud_credential_id = rancher2_cloud_credential.vsphere_homelab.id

  vsphere_config {
    cpu_count   = 2
    memory_size = 4096
    disk_size   = 16384
    cloudinit   = "https://pastebin.com/raw/ZYK9whBe"
    cfgparam    = ["disk.enableUUID=TRUE"]
    datastore   = var.vsphere_vm_datastore
    network     = [var.vsphere_vm_network]
    folder      = vsphere_folder.folder.path
  }

  engine_registry_mirror = ["https://${var.docker_registry}"]
}

resource rancher2_node_template large {
  name                = "4vCPU-4GiRAM-32GiSSD"
  cloud_credential_id = rancher2_cloud_credential.vsphere_homelab.id

  vsphere_config {
    cpu_count   = 4
    memory_size = 4096
    disk_size   = 32767
    cloudinit   = "https://pastebin.com/raw/ZYK9whBe"
    cfgparam    = ["disk.enableUUID=TRUE"]
    datastore   = var.vsphere_vm_datastore
    network     = [var.vsphere_vm_network]
    folder      = vsphere_folder.folder.path
  }

  engine_registry_mirror = ["https://${var.docker_registry}"]
}
