output traefik_ingress_fqdn {
  value = "${var.traefik_ingress_hostname}.${var.ingress_domain}"
}