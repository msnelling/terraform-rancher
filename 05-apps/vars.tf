variable nfs_server {
  default = "10.1.90.2"
}

variable hass_nfs_path {
  default = "/mnt/tank/rancher/pvs/home-assistant"
}

variable sonarr_nfs {
  default = {
    config = {
      name     = "sonarr-config"
      nfs_path = "/mnt/tank/rancher/pvs/sonarr-config"
      capacity = "1Gi"
    },
    downloads = {
      name     = "sonarr-downloads"
      nfs_path = "/mnt/tank/media/download"
      capacity = "10Gi"
    },
    media = {
      name     = "sonarr-tv"
      nfs_path = "/mnt/tank/media/TV Shows"
      capacity = "10Gi"
    }
  }
}

variable radarr_nfs {
  default = {
    config = {
      name     = "radarr-config"
      nfs_path = "/mnt/tank/rancher/pvs/radarr-config"
      capacity = "1Gi"
    },
    downloads = {
      name     = "radarr-downloads"
      nfs_path = "/mnt/tank/media/download"
      capacity = "10Gi"
    },
    media = {
      name     = "radarr-movies"
      nfs_path = "/mnt/tank/media/Video/Movies"
      capacity = "10Gi"
    }
  }
}

variable nzbget_node_selector {
  default = {
    gateway = "vpn",
  }
}

variable nzbget_nfs {
  default = {
    config = {
      name     = "nzbget-config"
      nfs_path = "/mnt/tank/rancher/pvs/nzbget-config"
      capacity = "1Gi"
    },
    downloads = {
      name     = "nzbget-downloads"
      nfs_path = "/mnt/tank/media/download/NZBGet"
      capacity = "10Gi"
    }
  }
}
