output ingress_fqdn {
  value = "${var.ingress_hostname}.${var.ingress_domain}"
}