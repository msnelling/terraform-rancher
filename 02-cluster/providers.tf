provider dns {
  update {
    server        = var.dns_update_server
    key_name      = var.dns_update_key
    key_algorithm = var.dns_update_algorithm
    key_secret    = var.dns_update_secret
  }
}

provider github {
  individual = true
  anonymous  = true
}

provider rancher2 {
  api_url   = data.terraform_remote_state.rancher.outputs.api_url
  token_key = data.terraform_remote_state.rancher.outputs.token_key
}

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

data vsphere_resource_pool pool {
  name          = var.vsphere_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

data vsphere_network vm {
  name          = var.vsphere_vm_network
  datacenter_id = data.vsphere_datacenter.dc.id
}
