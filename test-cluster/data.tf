data null_data_source values {
  count = length(var.k8s_cluster)

  inputs = {
    node_command = rancher2_cluster.cluster.cluster_registration_token[0].node_command
    address_ipv4 = split("/", var.k8s_cluster[count.index].address_cidr_ipv4)[0]
    role_params  = join(" ", formatlist("--%s ", var.k8s_cluster[count.index].roles))
    label_params = join(" ", formatlist("--label %s=%s ", keys(var.k8s_cluster[count.index].labels), values(var.k8s_cluster[count.index].labels)))
  }
}

data template_file cloud_config {
  count    = length(var.k8s_cluster)
  template = file("${path.module}/templates/cloud_config.yml.tpl")

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
