resource rancher2_namespace longhorn {
  name        = "longhorn-system"
  description = "Namespace for Longhorn storage provider"
  project_id  = data.rancher2_project.system.id
}

resource rancher2_secret backup {
  name         = var.longhorn_backup_secret
  namespace_id = rancher2_namespace.longhorn.id
  project_id   = data.rancher2_project.system.id
  data = {
    AWS_ENDPOINTS         = base64encode(var.longhorn_backup_s3_endpoint)
    AWS_ACCESS_KEY_ID     = base64encode(var.longhorn_backup_s3_access_key)
    AWS_SECRET_ACCESS_KEY = base64encode(var.longhorn_backup_s3_secret_key)
  }
}

resource rancher2_app longhorn {
  name             = "longhorn"
  template_name    = "longhorn"
  catalog_name     = "library"
  target_namespace = rancher2_namespace.longhorn.name
  project_id       = data.rancher2_project.system.id
  answers = {
    "defaultSettings.backupTarget"                 = var.longhorn_backup_target
    "defaultSettings.backupTargetCredentialSecret" = rancher2_secret.backup.name
  }
}
