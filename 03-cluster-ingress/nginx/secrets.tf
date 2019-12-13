resource rancher2_certificate ingress_tls {
  certs        = var.certificate_pem
  key          = var.private_key_pem
  name         = "ingress-default-cert"
  namespace_id = data.rancher2_namespace.nginx_ingress.id
  project_id   = var.project_id
}
