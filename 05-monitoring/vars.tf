###############################################################################
# DNS
variable dns_domain {
  default = "xmple.io"
}
variable dns_update_server {}
variable dns_update_key {}
variable dns_update_algorithm {}
variable dns_update_secret {}
variable dns_ingress_a_record {
  default = "ingress.k8s.xmple.io."
}

###############################################################################
# Loki
variable loki_hostname {
  default = "loki"
}
variable loki_domain {
  default = "k8s.xmple.io"
}
variable ingress_class {
  default = "traefik"
}