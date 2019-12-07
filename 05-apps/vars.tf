variable process_uid {
  default = 911
}

variable process_gid {
  default = 2001
}

variable vpn_node_selector {
  default = {
    gateway = "vpn",
  }
}

###############################################################################
# NFS
variable nfs_server {}

###############################################################################
# DNS
variable dns_domain {
  default = "xmple.io"
}
variable dns_update_server {}
variable dns_update_key {}
variable dns_update_algorithm {}
variable dns_update_secret {}
variable dns_ingress_a_record {
  default = "ingress.k8s.xmple.io."
}

###############################################################################
# Home Assistant
variable hass_hostname {
  default = "hass"
}

variable hass_nfs_path {
  default = "/mnt/tank/rancher/pvs/home-assistant"
}

###############################################################################
# Sonarr
variable sonarr_hostname {
  default = "sonarr"
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

###############################################################################
# Radarr
variable radarr_hostname {
  default = "radarr"
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
    movies = {
      name     = "radarr-movies"
      nfs_path = "/mnt/tank/media/Video/Movies"
      capacity = "10Gi"
    }
  }
}

###############################################################################
# Bazarr
variable bazarr_hostname {
  default = "bazarr"
}

variable bazarr_nfs {
  default = {
    config = {
      name     = "bazarr-config"
      nfs_path = "/mnt/tank/rancher/pvs/bazarr-config"
      capacity = "1Gi"
    },
    tv = {
      name     = "bazarr-tv"
      nfs_path = "/mnt/tank/media/TV Shows"
      capacity = "10Gi"
    },
    movies = {
      name     = "bazarr-movies"
      nfs_path = "/mnt/tank/media/Video/Movies"
      capacity = "10Gi"
    }
  }
}

###############################################################################
# NZBGet
variable nzbget_hostname {
  default = "nzbget"
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

###############################################################################
# qBittorrent
variable qbittorrent_hostname {
  default = "qbittorrent"
}

variable qbittorrent_nfs {
  default = {
    config = {
      name     = "qbittorrent-config"
      nfs_path = "/mnt/tank/rancher/pvs/qbittorrent-config"
      capacity = "1Gi"
    },
    data = {
      name     = "qbittorrent-data"
      nfs_path = "/mnt/tank/media/download/qBittorrent"
      capacity = "10Gi"
    }
  }
}

###############################################################################
# Loki
variable loki_hostname {
  default = "loki"
}
