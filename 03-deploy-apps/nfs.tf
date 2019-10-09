resource rancher2_namespace nfs_client_provisioner {
  name       = "nfs-client-provisioner"
  project_id = data.rancher2_project.system.id
}

resource rancher2_app nfs_client_provisioner {
  catalog_name     = "helm"
  name             = "nfs-client-provisioner"
  project_id       = data.rancher2_project.system.id
  target_namespace = rancher2_namespace.nfs_client_provisioner.name
  template_name    = "nfs-client-provisioner"
  template_version = "1.2.6"
  values_yaml      = <<EOF
nfs:
  path: ${var.nfs_path}
  server: ${var.nfs_server}
storageClass:
  name: ${var.nfs_storage_class}
  reclaimPolicy: Retain
EOF
}
