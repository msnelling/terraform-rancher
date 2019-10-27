resource rancher2_certificate traefik_tls {
  certs        = base64encode(acme_certificate.traefik_tls.certificate_pem)
  key          = base64encode(acme_certificate.traefik_tls.private_key_pem)
  name         = "traefik-default-tls"
  namespace_id = rancher2_namespace.traefik_ingress.id
  project_id   = data.rancher2_project.system.id
}

resource rancher2_secret traefik_admin_auth {
  name       = "traefik-dashboard-htpasswd"
  project_id = data.rancher2_project.system.id
  data = {
    users = base64encode("${var.admin_username}:${bcrypt(var.admin_password, 11)}")
  }
}
