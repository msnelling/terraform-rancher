provider vsphere {
  vsphere_server       = var.vsphere_server
  user                 = var.vsphere_username
  password             = var.vsphere_password
  allow_unverified_ssl = true
}

data vsphere_datacenter dc {
  name = var.vsphere_datacenter
}

data vsphere_datastore vm_datastore {
  name          = var.vsphere_vm_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data vsphere_datastore iso_datastore {
  name          = var.vsphere_iso_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data vsphere_resource_pool pool {}

data vsphere_network vm {
  name          = var.vsphere_vm_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data vsphere_network storage {
  name          = var.vsphere_storage_network
  datacenter_id = data.vsphere_datacenter.dc.id
}
