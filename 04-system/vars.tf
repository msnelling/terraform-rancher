###############################################################################
# NFS
variable nfs_server {}
variable nfs_path {}

###############################################################################
# DNS
variable dns_update_server {}
variable dns_update_key {}
variable dns_update_algorithm {}
variable dns_update_secret {}
variable dns_ingress_a_record {
  default = "ingress.k8s.xmple.io."
}

###############################################################################
# Longhorn
variable longhorn_backup_target {
  default = "s3://longhorn.k8s.xmple.io@minio/"
}
variable longhorn_backup_secret {
  default = "minio-secret"
}
variable longhorn_backup_s3_endpoint {}
variable longhorn_backup_s3_access_key {}
variable longhorn_backup_s3_secret_key {}
