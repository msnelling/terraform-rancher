data terraform_remote_state rancher {
  backend = "remote"
  config = {
    organization = "xmple"
    workspaces = {
      name = "rancher"
    }
  }
}

data github_user cluster_admin {
  username = var.github_username
}

data null_data_source node_values {
  count = length(var.cluster)

  inputs = {
    cpu_cores            = contains(keys(var.cluster[count.index]), "cpu_cores") ? var.cluster[count.index].cpu_cores : 1
    cpu_cores_per_socket = contains(keys(var.cluster[count.index]), "cpu_cores_per_socket") ? var.cluster[count.index].cpu_cores_per_socket : 1
    cpu_limit            = contains(keys(var.cluster[count.index]), "cpu_limit") ? var.cluster[count.index].cpu_limit : -1
    node_command         = rancher2_cluster.cluster.cluster_registration_token[0].node_command
    address_ipv4         = split("/", var.cluster[count.index].address_cidr_ipv4)[0]
    role_params          = join(" ", formatlist("--%s ", var.cluster[count.index].roles))
    label_params         = join(" ", formatlist("--label %s=%s ", keys(var.cluster[count.index].labels), values(var.cluster[count.index].labels)))
  }
}

data vsphere_virtual_machine template {
  name          = var.vsphere_vm_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

data vsphere_tag rancher {
  name        = data.terraform_remote_state.rancher.outputs.vm_tag_rancher
  category_id = data.terraform_remote_state.rancher.outputs.vm_tag_catagory_id
}