variable nfs_server {
  default = "10.1.90.2"
}

variable hass_nfs_path {
  default = "/mnt/tank/rancher/pvs/home-assistant"
}

variable sonarr_nfs_paths {
  default = [
    {
      name     = "sonarr-config"
      nfs_path = "/mnt/tank/rancher/pvs/sonarr-config"
      capacity = "1Gi"
    },
    {
      name     = "sonarr-downloads"
      nfs_path = "/mnt/tank/media/downloads"
      capacity = "10Gi"
    },
    {
      name     = "sonarr-tv"
      nfs_path = "/mnt/tank/media/TV Shows"
      capacity = "10Gi"
    }
  ]
}