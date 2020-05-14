output default_storage_class {
  value = "longhorn"
}

output nvme_storage_class {
  value = kubernetes_storage_class.longhorn_nvme.metadata[0].name
}

output ssd_storage_class {
  value = kubernetes_storage_class.longhorn_ssd.metadata[0].name
}
