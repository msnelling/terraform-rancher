output default_storage_class {
  value = "longhorn"
}

output fast_storage_class {
  value = kubernetes_storage_class.longhorn_fast.metadata[0].name
}

output nfs_storage_class {
  value = var.nfs_storage_class
}