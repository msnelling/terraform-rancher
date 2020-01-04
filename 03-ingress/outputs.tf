output builtin_ingress_fqdn {
  value = "${var.builtin_ingress_hostname}.${var.ingress_domain}"
}

output nginxinc_ingress_fqdn {
  value = "${var.nginxinc_ingress_hostname}.${var.ingress_domain}"
}

output traefik_ingress_fqdn {
  value = "${var.traefik_ingress_hostname}.${var.ingress_domain}"
}