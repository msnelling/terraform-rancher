variable process_uid {
  default = 911
}

variable process_gid {
  default = 2001
}

###############################################################################
# NFS
variable nfs_server {
  default = "10.1.90.2"
}

variable vpn_node_selector {
  default = {
    gateway = "vpn",
  }
}

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
  default = "k8s.xmple.io."
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
    media = {
      name     = "radarr-movies"
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
# rTorrent/Flood
variable rtorrent_hostname {
  default = "rtorrent"
}

variable rtorrent_nfs {
  default = {
    config = {
      name     = "rtorrent-config"
      nfs_path = "/mnt/tank/rancher/pvs/rtorrent-config"
      capacity = "1Gi"
    },
    data = {
      name     = "rtorrent-data"
      nfs_path = "/mnt/tank/media/download/rTorrent"
      capacity = "10Gi"
    }
  }
}
