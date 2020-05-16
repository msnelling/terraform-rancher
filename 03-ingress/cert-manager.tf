resource rancher2_catalog jetstack {
  name       = "jetstack"
  url        = "https://charts.jetstack.io"
  version    = "helm_v2"
  scope      = "cluster"
  cluster_id = local.cluster_id
  refresh    = true
}

resource rancher2_namespace cert_manager {
  name       = "cert-manager"
  project_id = local.system_project_id
}

resource rancher2_app cert_manager {
  name             = "cert-manager"
  template_name    = "cert-manager"
  template_version = "v${var.cert_manager_version}"
  catalog_name     = "${local.cluster_id}:${rancher2_catalog.jetstack.name}"
  project_id       = local.system_project_id
  target_namespace = rancher2_namespace.cert_manager.name
  values_yaml      = base64encode(templatefile("${path.module}/templates/cert_manager_values.yaml.tpl", {}))
}
