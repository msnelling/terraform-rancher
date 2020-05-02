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

data vsphere_resource_pool pool {
  name          = var.vsphere_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

data vsphere_network vm {
  name          = var.vsphere_vm_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data github_user cluster_admin {
  username = var.github_username
}
