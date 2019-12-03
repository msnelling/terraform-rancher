resource dns_a_record_set ingress {
  zone      = "${var.ingress_domain}."
  name      = var.ingress_hostname
  addresses = module.nginx.ingress_ips
  ttl       = 60
}
