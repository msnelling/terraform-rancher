terraform {
  backend "remote" {
    organization = "xmple"
    workspaces {
      name = "k8s-ingress"
    }
  }
}

module nginx {
  source          = "./nginx"
  project_id      = data.rancher2_project.system.id
  certificate_pem = base64encode(acme_certificate.ingress_tls.certificate_pem)
  private_key_pem = base64encode(tls_private_key.ingress_tls.private_key_pem)
}
