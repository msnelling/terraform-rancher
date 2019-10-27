locals {
  traefik_password = bcrypt(var.admin_password, 11)
  consul_password  = bcrypt(var.admin_password, 11)
}

/*
resource rancher2_secret cloudflare_api {
  name         = "cloudflare-api-key"
  project_id   = data.rancher2_project.system.id
  namespace_id = "cert-manager"
  data = {
    api-key = base64encode(var.cloudflare_api_key)
  }
}
*/

resource rancher2_certificate traefik_tls {
  certs        = base64encode(acme_certificate.traefik_tls.certificate_pem)
  key          = base64encode(acme_certificate.traefik_tls.private_key_pem)
  name         = "xmple-io-tls"
  namespace_id = rancher2_namespace.traefik_ingress.id
  project_id   = data.rancher2_project.system.id
}

resource rancher2_secret traefik_admin_auth {
  name       = "traefik-dashboard-htpasswd"
  project_id = data.rancher2_project.system.id
  data = {
    users = base64encode("${var.admin_username}:${local.traefik_password}")
  }
}

/*
resource rancher2_secret consul_admin_auth {
  name       = "consul-admin-auth"
  project_id = data.rancher2_project.system.id
  data = {
    users = base64encode("${var.admin_username}:${local.consul_password}")
  }
}
*/