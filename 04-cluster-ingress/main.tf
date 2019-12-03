terraform {
  backend "remote" {
    organization = "xmple"
    workspaces {
      name = "k8s-ingress"
    }
  }
}

/*
module traefik {
  source         = "./traefik"
  project_id     = data.rancher2_project.system.id
  cluster_id     = data.terraform_remote_state.cluster.outputs.cluster_id
  admin_hostname = var.traefik_admin_hostname
  admin_username = var.traefik_admin_username
  admin_password = var.traefik_admin_password
  certificate_pem = base64encode(acme_certificate.ingress_tls.certificate_pem)
  private_key_pem = base64encode(acme_certificate.ingress_tls.private_key_pem)
}
*/

module nginx {
  source          = "./nginx"
  project_id      = data.rancher2_project.system.id
  certificate_pem = base64encode(acme_certificate.ingress_tls.certificate_pem)
  private_key_pem = base64encode(acme_certificate.ingress_tls.private_key_pem)
}
