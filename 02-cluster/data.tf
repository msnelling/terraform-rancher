data terraform_remote_state rancher {
  backend = "remote"
  config = {
    organization = "xmple"
    workspaces = {
      name = "rancher"
    }
  }
  #  backend = "local"
  #  config = {
  #    path    = "${path.module}/../01-rancher-server/terraform.tfstate"
  #  }
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

data template_file cloud_config_rancheros {
  count    = length(var.cluster)
  template = file("${path.module}/templates/cloud_config_rancheros.yaml")

  vars = {
    rancher_ssh_key   = tls_private_key.ssh.public_key_openssh
    extra_ssh_keys    = join(",", data.github_user.cluster_admin.ssh_keys)
    hostname          = "${var.cluster[count.index].name}.${var.k8s_domain}"
    docker_registry   = var.docker_registry
    dns_servers       = join(",", var.dns_servers)
    dns_domain        = var.k8s_domain
    address_cidr_ipv4 = var.cluster[count.index].address_cidr_ipv4
    gateway_ipv4      = var.cluster[count.index].gateway_ipv4
  }
}

data vsphere_tag rancher {
  name        = data.terraform_remote_state.rancher.outputs.vm_tag_rancher
  category_id = data.terraform_remote_state.rancher.outputs.vm_tag_catagory_id
}