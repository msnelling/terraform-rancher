resource dns_a_record_set node {
  count = length(var.cluster)

  zone      = "${var.k8s_domain}."
  name      = var.cluster[count.index].name
  addresses = [data.null_data_source.node_values[count.index].outputs["address_ipv4"]]
  ttl       = 60
}
