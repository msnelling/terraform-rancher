resource dns_a_record_set builtin_ingress {
  zone      = "${var.ingress_domain}."
  name      = var.builtin_ingress_hostname
  addresses = kubernetes_service.builtin_ingress.load_balancer_ingress.*.ip
  ttl       = 60
}

resource dns_a_record_set nginxinc_ingress {
  zone      = "${var.ingress_domain}."
  name      = var.nginxinc_ingress_hostname
  addresses = data.kubernetes_service.nginxinc.load_balancer_ingress.*.ip
  ttl       = 60
}

resource dns_a_record_set traefik_ingress {
  zone      = "${var.ingress_domain}."
  name      = var.traefik_ingress_hostname
  addresses = data.kubernetes_service.traefik.load_balancer_ingress.*.ip
  ttl       = 60
}
