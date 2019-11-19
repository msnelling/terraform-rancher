resource rancher2_namespace sonarr {
  name        = "sonarr"
  description = "Namespace for sonarr app components"
  project_id  = data.rancher2_project.default.id
}

resource kubernetes_persistent_volume sonarr {
  count = length(var.sonarr_nfs)
  metadata {
    name = values(var.sonarr_nfs)[count.index].name
  }
  spec {
    capacity = {
      storage = values(var.sonarr_nfs)[count.index].capacity
    }
    access_modes                     = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    persistent_volume_source {
      nfs {
        server = var.nfs_server
        path   = values(var.sonarr_nfs)[count.index].nfs_path
      }
    }
  }
}

resource kubernetes_persistent_volume_claim sonarr {
  count = length(var.sonarr_nfs)
  metadata {
    name      = values(var.sonarr_nfs)[count.index].name
    namespace = rancher2_namespace.sonarr.name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = values(var.sonarr_nfs)[count.index].capacity
      }
    }
    volume_name = kubernetes_persistent_volume.sonarr[count.index].metadata.0.name
  }
}

data template_file sonarr_values {
  template = file("${path.module}/templates/sonarr_values.yaml.tpl")
  vars = {
    process_uid   = var.process_uid
    process_gid   = var.process_gid
    hostname      = "${var.sonarr_hostname}.${var.dns_domain}"
    pvc_config    = var.sonarr_nfs.config.name
    pvc_downloads = var.sonarr_nfs.downloads.name
    pvc_media     = var.sonarr_nfs.media.name
    node_selector = yamlencode(var.vpn_node_selector)
  }
}

resource rancher2_app sonarr {
  name             = "sonarr"
  catalog_name     = "${data.terraform_remote_state.cluster.outputs.cluster_id}:${rancher2_catalog.custom.name}"
  project_id       = data.rancher2_project.default.id
  target_namespace = rancher2_namespace.sonarr.name
  template_name    = "sonarr"
  values_yaml      = base64encode(data.template_file.sonarr_values.rendered)
}

resource dns_cname_record sonarr {
  zone  = "${var.dns_domain}."
  name  = var.sonarr_hostname
  cname = var.dns_ingress_a_record
  ttl   = 60
}
