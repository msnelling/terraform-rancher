resource rancher2_namespace radarr {
  name        = "radarr"
  description = "Namespace for radarr app components"
  project_id  = local.default_project_id
}

resource kubernetes_persistent_volume radarr_nfs {
  count = length(var.radarr_nfs)
  metadata {
    name = values(var.radarr_nfs)[count.index].name
  }
  spec {
    capacity = {
      storage = values(var.radarr_nfs)[count.index].capacity
    }
    storage_class_name               = "nfs-client"
    access_modes                     = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    persistent_volume_source {
      nfs {
        server = var.nfs_server
        path   = values(var.radarr_nfs)[count.index].nfs_path
      }
    }
  }
}

resource kubernetes_persistent_volume_claim radarr_nfs {
  count = length(var.radarr_nfs)
  metadata {
    name      = values(var.radarr_nfs)[count.index].name
    namespace = rancher2_namespace.radarr.name
  }
  spec {
    storage_class_name = kubernetes_persistent_volume.radarr_nfs[count.index].spec[0].storage_class_name
    access_modes       = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = values(var.radarr_nfs)[count.index].capacity
      }
    }
    volume_name = kubernetes_persistent_volume.radarr_nfs[count.index].metadata.0.name
  }
}

resource kubernetes_persistent_volume radarr_iscsi {
  count = length(var.radarr_iscsi)
  metadata {
    name = values(var.radarr_iscsi)[count.index].name
  }
  spec {
    capacity = {
      storage = values(var.radarr_iscsi)[count.index].capacity
    }
    storage_class_name               = "iscsi"
    access_modes                     = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    persistent_volume_source {
      iscsi {
        fs_type       = "ext4"
        iqn           = "${var.iscsi_iqn_base}:${values(var.radarr_iscsi)[count.index].name}"
        lun           = values(var.radarr_iscsi)[count.index].lun
        target_portal = var.iscsi_target
      }
    }
  }
}

resource kubernetes_persistent_volume_claim radarr_iscsi {
  count = length(var.radarr_iscsi)
  metadata {
    name      = values(var.radarr_iscsi)[count.index].name
    namespace = rancher2_namespace.radarr.name
  }
  spec {
    storage_class_name = kubernetes_persistent_volume.radarr_iscsi[count.index].spec[0].storage_class_name
    access_modes       = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = kubernetes_persistent_volume.radarr_iscsi[count.index].spec[0].capacity.storage
      }
    }
    volume_name = kubernetes_persistent_volume.radarr_iscsi[count.index].metadata[0].name
  }
}

data template_file radarr_values {
  template = file("${path.module}/templates/radarr_values.yaml.tpl")
  vars = {
    process_uid        = var.process_uid
    process_gid        = var.process_gid
    ingress_class      = var.ingress_class
    certificate_issuer = var.certificate_issuer
    hostname           = "${var.radarr_hostname}.${var.dns_domain}"
    pvc_config         = var.radarr_iscsi.config.name
    pvc_downloads      = var.radarr_nfs.downloads.name
    pvc_movies         = var.radarr_nfs.movies.name
    node_selector      = yamlencode(var.vpn_node_selector)
  }
}

resource rancher2_app radarr {
  name             = "radarr"
  catalog_name     = "${local.cluster_id}:${data.rancher2_catalog.internal.name}"
  project_id       = local.default_project_id
  target_namespace = rancher2_namespace.radarr.name
  template_name    = "radarr"
  values_yaml      = base64encode(data.template_file.radarr_values.rendered)

  depends_on = [
    kubernetes_persistent_volume_claim.radarr_nfs,
    kubernetes_persistent_volume_claim.radarr_iscsi,
  ]
}

resource dns_cname_record radarr {
  zone  = "${var.dns_domain}."
  name  = var.radarr_hostname
  cname = var.dns_ingress_a_record
  ttl   = 60
}
