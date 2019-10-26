resource tls_private_key acme_private_key {
  algorithm = "RSA"
}

resource acme_registration reg {
  account_key_pem = tls_private_key.acme_private_key.private_key_pem
  email_address   = var.acme_email
}

resource acme_certificate traefik_tls {
  account_key_pem           = acme_registration.reg.account_key_pem
  common_name               = "k8s.xmple.io"
  subject_alternative_names = ["*.k8s.xmple.io"]
  recursive_nameservers     = ["1.1.1.1:53", "1.0.0.1:53"]

  dns_challenge {
    provider = "cloudflare"
    config = {
      CF_API_EMAIL = var.cloudflare_api_email
      CF_API_KEY   = var.cloudflare_api_key
    }
  }
}