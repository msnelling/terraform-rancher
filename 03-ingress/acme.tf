resource tls_private_key acme_account {
  algorithm = "RSA"
}

resource tls_private_key ingress_tls {
  algorithm = "RSA"
}

resource acme_registration reg {
  email_address   = var.acme_email
  account_key_pem = tls_private_key.acme_account.private_key_pem
}

resource tls_cert_request ingress_tls {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.ingress_tls.private_key_pem

  subject {
    common_name = var.ingress_domain
  }

  dns_names = [
    "*.${var.ingress_domain}",
  ]
}

resource acme_certificate ingress_tls {
  account_key_pem         = acme_registration.reg.account_key_pem
  certificate_request_pem = tls_cert_request.ingress_tls.cert_request_pem
  min_days_remaining      = 20
  recursive_nameservers   = ["1.1.1.1:53", "1.0.0.1:53"]

  dns_challenge {
    provider = "cloudflare"
    config = {
      CF_API_EMAIL = var.cloudflare_api_email
      CF_API_KEY   = var.cloudflare_api_key
    }
  }
}