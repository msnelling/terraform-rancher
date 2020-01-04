resource dns_a_record_set nginx_ingress {
  zone      = "${var.ingress_domain}."
  name      = var.nginx_ingress_hostname
  addresses = module.nginx.ingress_ips
  ttl       = 60
}

resource dns_a_record_set traefik_ingress {
  zone      = "${var.ingress_domain}."
  name      = var.traefik_ingress_hostname
  addresses = data.kubernetes_service.traefik.load_balancer_ingress.*.ip
  ttl       = 60
}
