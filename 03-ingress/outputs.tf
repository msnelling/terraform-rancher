output nginx_ingress_fqdn {
  value = "${var.nginx_ingress_hostname}.${var.ingress_domain}"
}

output traefik_ingress_fqdn {
  value = "${var.traefik_ingress_hostname}.${var.ingress_domain}"
}