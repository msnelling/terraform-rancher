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
  values_yaml      = <<EOF
StorageClass: ${var.nfs_storage_class}
uiService:
  type: ClusterIP
EOF

  depends_on = [rancher2_app.nfs_client_provisioner]
}
