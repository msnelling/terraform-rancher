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

data null_data_source node_values {
  count = length(var.k8s_cluster)

  inputs = {
    cpu_cores            = contains(keys(var.k8s_cluster[count.index]), "cpu_cores") ? var.k8s_cluster[count.index].cpu_cores : 1
    cpu_cores_per_socket = contains(keys(var.k8s_cluster[count.index]), "cpu_cores_per_socket") ? var.k8s_cluster[count.index].cpu_cores_per_socket : 1
    cpu_limit            = contains(keys(var.k8s_cluster[count.index]), "cpu_limit") ? var.k8s_cluster[count.index].cpu_limit : -1
    node_command         = rancher2_cluster.cluster.cluster_registration_token[0].node_command
    address_ipv4         = split("/", var.k8s_cluster[count.index].address_cidr_ipv4)[0]
    role_params          = join(" ", formatlist("--%s ", var.k8s_cluster[count.index].roles))
    label_params         = join(" ", formatlist("--label %s=%s ", keys(var.k8s_cluster[count.index].labels), values(var.k8s_cluster[count.index].labels)))
  }
}

data template_file cloud_config_rancheros {
  count    = length(var.k8s_cluster)
  template = file("${path.module}/templates/cloud_config_rancheros.yaml")

  vars = {
    ssh_key           = tls_private_key.ssh.public_key_openssh
    hostname          = "${var.k8s_cluster[count.index].name}.${var.k8s_domain}"
    docker_registry   = var.docker_registry
    dns_servers       = join(",", var.dns_servers)
    dns_domain        = var.k8s_domain
    address_cidr_ipv4 = var.k8s_cluster[count.index].address_cidr_ipv4
    gateway_ipv4      = var.k8s_cluster[count.index].gateway_ipv4
  }
}