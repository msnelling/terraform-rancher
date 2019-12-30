resource rancher2_namespace reloader {
  name        = "reloader"
  description = "Namespace for Reloader app"
  project_id  = data.rancher2_project.system.id
}

resource rancher2_app reloader {
  name             = "reloader"
  template_name    = "reloader"
  catalog_name     = "helm"
  project_id       = data.rancher2_project.system.id
  target_namespace = rancher2_namespace.reloader.name
}
