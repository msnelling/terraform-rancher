resource rancher2_catalog traefik {
  name        = "traefik"
  scope       = "cluster"
  cluster_id  = var.cluster_id
  url         = "https://github.com/containous/traefik-helm-chart"
}

resource rancher2_namespace traefik {
  name       = "traefik"
  project_id = var.project_id
}

data template_file traefik_values {
  template = file("${path.module}/templates/traefik_values.yaml.tpl")
}

resource rancher2_app traefik {
  name             = "traefik"
  template_name    = "traefik"
  catalog_name     = "${var.cluster_id}:${rancher2_catalog.traefik.name}"
  project_id       = var.project_id
  target_namespace = rancher2_namespace.traefik.name
  values_yaml      = base64encode(data.template_file.traefik_values.rendered)
}