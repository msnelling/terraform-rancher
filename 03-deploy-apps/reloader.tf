resource rancher2_namespace reloader {
  name        = "reloader"
  description = "Namespace for Reloader components"
  project_id  = data.rancher2_project.system.id
}

resource rancher2_app reloader {
  catalog_name     = "helm"
  name             = "reloader"
  project_id       = data.rancher2_project.system.id
  target_namespace = rancher2_namespace.reloader.name
  template_name    = "reloader"
  template_version = "1.1.3"
}
