resource dns_a_record_set node {
  count = length(var.k8s_cluster)

  zone      = "${var.k8s_domain}."
  name      = var.k8s_cluster[count.index].name
  addresses = [data.null_data_source.values[count.index].outputs["address_ipv4"]]
  ttl       = 60
}
