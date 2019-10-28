resource rancher2_namespace consul {
  name       = "consul"
  project_id = data.rancher2_project.default.id
}

resource rancher2_app consul {
  catalog_name     = "helm"
  name             = "consul"
  project_id       = data.rancher2_project.default.id
  target_namespace = rancher2_namespace.consul.name
  template_name    = "consul"
  answers = {
    "StorageClass" = var.nfs_storage_class
    "uiService.type" = "ClusterIP"
  }

  depends_on = [rancher2_app.nfs_client_provisioner]
}

resource rancher2_secret consul_admin_auth {
  name       = "consul-admin-auth"
  project_id = data.rancher2_project.system.id
  data = {
    users = base64encode("${var.admin_username}:${bcrypt(var.admin_password, 11)}")
  }
}
