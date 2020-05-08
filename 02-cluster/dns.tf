resource dns_a_record_set node {
  count = length(var.cluster)

  zone      = "${var.k8s_domain}."
  name      = var.cluster[count.index].name
  addresses = [vsphere_virtual_machine.node[count.index].default_ip_address]
  ttl       = 60
}
