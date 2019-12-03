resource tls_private_key acme_private_key {
  algorithm = "RSA"
}

resource acme_registration reg {
  email_address   = var.acme_email
  account_key_pem = tls_private_key.acme_private_key.private_key_pem
}

resource acme_certificate ingress_tls {
  account_key_pem           = acme_registration.reg.account_key_pem
  common_name               = var.ingress_domain
  subject_alternative_names = ["*.${var.ingress_domain}"]
  recursive_nameservers     = ["1.1.1.1:53", "1.0.0.1:53"]

  dns_challenge {
    provider = "cloudflare"
    config = {
      CF_API_EMAIL = var.cloudflare_api_email
      CF_API_KEY   = var.cloudflare_api_key
    }
  }
}