resource rancher2_namespace sonarr {
  name        = "sonarr"
  description = "Namespace for sonarr app components"
  project_id  = local.default_project_id
}

resource kubernetes_persistent_volume sonarr_nfs {
  count = length(var.sonarr_nfs)
  metadata {
    name = values(var.sonarr_nfs)[count.index].name
  }
  spec {
    capacity = {
      storage = values(var.sonarr_nfs)[count.index].capacity
    }
    storage_class_name               = "nfs-client"
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

resource kubernetes_persistent_volume_claim sonarr_nfs {
  count = length(var.sonarr_nfs)
  metadata {
    name      = values(var.sonarr_nfs)[count.index].name
    namespace = rancher2_namespace.sonarr.name
  }
  spec {
    storage_class_name = "nfs-client"
    access_modes       = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = values(var.sonarr_nfs)[count.index].capacity
      }
    }
    volume_name = kubernetes_persistent_volume.sonarr_nfs[count.index].metadata.0.name
  }
}

resource kubernetes_persistent_volume sonarr_iscsi {
  count = length(var.sonarr_iscsi)
  metadata {
    name = values(var.sonarr_iscsi)[count.index].name
  }
  spec {
    capacity = {
      storage = values(var.sonarr_iscsi)[count.index].capacity
    }
    storage_class_name               = "iscsi"
    access_modes                     = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    persistent_volume_source {
      iscsi {
        fs_type       = "ext4"
        iqn           = "${var.iscsi_iqn_base}:${values(var.sonarr_iscsi)[count.index].name}"
        lun           = values(var.sonarr_iscsi)[count.index].lun
        target_portal = var.iscsi_target
      }
    }
  }
}

resource kubernetes_persistent_volume_claim sonarr_iscsi {
  count = length(var.sonarr_iscsi)
  metadata {
    name      = values(var.sonarr_iscsi)[count.index].name
    namespace = rancher2_namespace.sonarr.name
  }
  spec {
    storage_class_name = kubernetes_persistent_volume.sonarr_iscsi[count.index].spec[0].storage_class_name
    access_modes       = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = kubernetes_persistent_volume.sonarr_iscsi[count.index].spec[0].capacity.storage
      }
    }
    volume_name = kubernetes_persistent_volume.sonarr_iscsi[count.index].metadata[0].name
  }
}

data template_file sonarr_values {
  template = file("${path.module}/templates/sonarr_values.yaml.tpl")
  vars = {
    process_uid        = var.process_uid
    process_gid        = var.process_gid
    ingress_class      = var.ingress_class
    certificate_issuer = var.certificate_issuer
    hostname           = "${var.sonarr_hostname}.${var.dns_domain}"
    pvc_config         = var.sonarr_iscsi.config.name
    pvc_downloads      = var.sonarr_nfs.downloads.name
    pvc_media          = var.sonarr_nfs.media.name
    node_selector      = yamlencode(var.vpn_node_selector)
  }
}

resource rancher2_app sonarr {
  name             = "sonarr"
  template_name    = "sonarr"
  catalog_name     = "${local.cluster_id}:${data.rancher2_catalog.internal.name}"
  project_id       = local.default_project_id
  target_namespace = rancher2_namespace.sonarr.name
  values_yaml      = base64encode(data.template_file.sonarr_values.rendered)

  depends_on = [
    kubernetes_persistent_volume_claim.sonarr_nfs,
    kubernetes_persistent_volume_claim.sonarr_iscsi,
  ]
}

resource dns_cname_record sonarr {
  zone  = "${var.dns_domain}."
  name  = var.sonarr_hostname
  cname = var.dns_ingress_a_record
  ttl   = 60
}
