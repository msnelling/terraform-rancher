variable ingress_domain {}
variable ingress_hostname {
  default = "ingress"
}

###############################################################################
# ACME
variable acme_email {}

###############################################################################
# Cloudflare
variable cloudflare_api_email {}
variable cloudflare_api_key {}

###############################################################################
# Traefik
variable traefik_admin_hostname {}
variable traefik_admin_username {}
variable traefik_admin_password {}

###############################################################################
# Metal-LB
variable metallb_image_tag {
  default = "v0.8.3"
}
variable metallb_address_pool {}

###############################################################################
# RFC2136
variable dns_update_server {}
variable dns_update_key {}
variable dns_update_algorithm {}
variable dns_update_secret {}
