resource rancher2_namespace rtorrent {
  name        = "rtorrent"
  description = "Namespace for rtorrent app components"
  project_id  = data.rancher2_project.default.id
}

resource kubernetes_persistent_volume rtorrent {
  count = length(var.rtorrent_nfs)
  metadata {
    name = values(var.rtorrent_nfs)[count.index].name
  }
  spec {
    capacity = {
      storage = values(var.rtorrent_nfs)[count.index].capacity
    }
    access_modes                     = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    persistent_volume_source {
      nfs {
        server = var.nfs_server
        path   = values(var.rtorrent_nfs)[count.index].nfs_path
      }
    }
  }
}

resource kubernetes_persistent_volume_claim rtorrent {
  count = length(var.rtorrent_nfs)
  metadata {
    name      = values(var.rtorrent_nfs)[count.index].name
    namespace = rancher2_namespace.rtorrent.name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = values(var.rtorrent_nfs)[count.index].capacity
      }
    }
    volume_name = kubernetes_persistent_volume.rtorrent[count.index].metadata.0.name
  }
}

data template_file rtorrent_values {
  template = file("${path.module}/templates/rtorrent_values.yaml.tpl")
  vars = {
    process_uid   = var.process_uid
    process_gid   = var.process_gid
    hostname      = "${var.rtorrent_hostname}.${var.dns_domain}"
    pvc_config    = var.rtorrent_nfs.config.name
    pvc_data      = var.rtorrent_nfs.data.name
    node_selector = yamlencode(var.vpn_node_selector)
  }
}

resource rancher2_app rtorrent {
  name             = "rtorrent"
  catalog_name     = "${data.terraform_remote_state.cluster.outputs.cluster_id}:${rancher2_catalog.custom.name}"
  project_id       = data.rancher2_project.default.id
  target_namespace = rancher2_namespace.rtorrent.name
  template_name    = "rtorrent"
  values_yaml      = base64encode(data.template_file.rtorrent_values.rendered)
}

resource dns_cname_record rtorrent {
  zone  = "${var.dns_domain}."
  name  = var.rtorrent_hostname
  cname = var.dns_ingress_a_record
  ttl   = 60
}
