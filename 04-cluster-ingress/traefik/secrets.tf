resource rancher2_certificate ingress_tls {
  certs        = var.certificate_pem
  key          = var.private_key_pem
  name         = "traefik-default-tls"
  namespace_id = rancher2_namespace.traefik_ingress.id
  project_id   = var.project_id
}

resource rancher2_secret traefik_admin_auth {
  name       = "traefik-dashboard-htpasswd"
  project_id = var.project_id
  data = {
    users = base64encode("${var.admin_username}:${bcrypt(var.admin_password, 11)}")
  }
}
