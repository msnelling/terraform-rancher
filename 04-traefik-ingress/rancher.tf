resource rancher2_catalog traefik {
  name        = "traefik"
  url         = "https://github.com/msnelling/terraform-rancher.git"
  description = "Temporary catalog hosting a Traefik v2.0 chart"
}

resource rancher2_namespace traefik_ingress {
  name       = "traefik-ingress"
  project_id = data.rancher2_project.system.id
}

/*
resource kubernetes_config_map traefik {
  metadata {
    name      = "traefik-config"
    namespace = rancher2_namespace.traefik_ingress.name
  }

  data = {
    "traefik.yaml" = data.template_file.traefik_config.rendered
  }
}
*/

resource rancher2_app traefik_ingress {
  catalog_name     = rancher2_catalog.traefik.name
  name             = "traefik"
  project_id       = data.rancher2_project.system.id
  target_namespace = rancher2_namespace.traefik_ingress.name
  template_name    = "traefik"
  force_upgrade    = true
  answers = {
    "dashboard.enabled"                             = true
    "dashboard.hostname"                            = var.traefik_dashboard_hostname
    "dashboard.htpasswd"                            = "${var.admin_username}:${bcrypt(var.admin_password)}"
    "dashboard.ingressLegacy.tls.enabled"           = true
    "dashboard.ingressLegacy.tls.certificateSecret" = rancher2_certificate.traefik_tls.name
    "acme.persistence.enabled"                      = false
  }

  depends_on = [
    data.external.catalog_refresh,
  ]
}