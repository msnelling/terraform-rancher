variable ingress_domain {}

variable traefik_ingress_hostname {
  default = "traefik"
}

###############################################################################
# ACME
variable acme_server_url {
  default = "https://acme-v02.api.letsencrypt.org/directory"
}
variable acme_email {}

###############################################################################
# Cert-Manager
variable cert_manager_version {
  default = "0.15.0"
}

###############################################################################
# Cloudflare
variable cloudflare_api_email {}
variable cloudflare_api_key {}

###############################################################################
# RFC2136
variable dns_update_server {}
variable dns_update_key {}
variable dns_update_algorithm {}
variable dns_update_secret {}
