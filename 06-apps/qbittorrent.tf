resource rancher2_namespace qbittorrent {
  name        = "qbittorrent"
  description = "Namespace for qBittorrent app components"
  project_id  = data.rancher2_project.default.id
}

resource kubernetes_persistent_volume qbittorrent_nfs {
  count = length(var.qbittorrent_nfs)
  metadata {
    name = values(var.qbittorrent_nfs)[count.index].name
  }
  spec {
    capacity = {
      storage = values(var.qbittorrent_nfs)[count.index].capacity
    }
    storage_class_name               = data.terraform_remote_state.system.outputs.nfs_storage_class
    access_modes                     = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    persistent_volume_source {
      nfs {
        server = var.nfs_server
        path   = values(var.qbittorrent_nfs)[count.index].nfs_path
      }
    }
  }
}

resource kubernetes_persistent_volume_claim qbittorrent_nfs {
  count = length(var.qbittorrent_nfs)
  metadata {
    name      = values(var.qbittorrent_nfs)[count.index].name
    namespace = rancher2_namespace.qbittorrent.name
  }
  spec {
    storage_class_name = kubernetes_persistent_volume.qbittorrent_nfs[count.index].spec[0].storage_class_name
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = values(var.qbittorrent_nfs)[count.index].capacity
      }
    }
    volume_name = kubernetes_persistent_volume.qbittorrent_nfs[count.index].metadata.0.name
  }
}

data template_file qbittorrent_values {
  template = file("${path.module}/templates/qbittorrent_values.yaml.tpl")
  vars = {
    process_uid        = var.process_uid
    process_gid        = var.process_gid
    certificate_issuer = var.certificate_issuer
    hostname           = "${var.qbittorrent_hostname}.${var.dns_domain}"
    pvc_config         = var.qbittorrent_nfs.config.name
    pvc_data           = var.qbittorrent_nfs.data.name
    node_selector      = yamlencode(var.vpn_node_selector)
  }
}

resource rancher2_app qbittorrent {
  name             = "qbittorrent"
  template_name    = "qbittorrent"
  catalog_name     = "${data.terraform_remote_state.cluster.outputs.cluster_id}:${rancher2_catalog.custom.name}"
  project_id       = data.rancher2_project.default.id
  target_namespace = rancher2_namespace.qbittorrent.name
  values_yaml      = base64encode(data.template_file.qbittorrent_values.rendered)

  depends_on = [
    kubernetes_persistent_volume_claim.qbittorrent_nfs,
  ]
}

resource dns_cname_record qbittorrent {
  zone  = "${var.dns_domain}."
  name  = var.qbittorrent_hostname
  cname = var.dns_ingress_a_record
  ttl   = 60
}
