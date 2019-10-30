resource rancher2_namespace nfs_client_provisioner {
  name        = "nfs-client-provisioner"
  description = "Namespace for nfs-client-provisioner app components"
  project_id  = data.rancher2_project.system.id
}

resource rancher2_app nfs_client_provisioner {
  name             = "nfs-client-provisioner"
  catalog_name     = "helm"
  project_id       = data.rancher2_project.system.id
  target_namespace = rancher2_namespace.nfs_client_provisioner.name
  template_name    = "nfs-client-provisioner"
  answers = {
    "nfs.server"                 = "${var.nfs_server}"
    "nfs.path"                   = "${var.hass_nfs_path}"
    "storageClass.name"          = "${var.nfs_storage_class}"
    "storageClass.reclaimPolicy" = "Retain"
  }
}
