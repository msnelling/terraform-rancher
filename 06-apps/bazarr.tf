resource rancher2_namespace bazarr {
  name        = "bazarr"
  description = "Namespace for bazarr app components"
  project_id  = data.rancher2_project.default.id
}

resource kubernetes_persistent_volume bazarr_nfs {
  count = length(var.bazarr_nfs)
  metadata {
    name = values(var.bazarr_nfs)[count.index].name
  }
  spec {
    capacity = {
      storage = values(var.bazarr_nfs)[count.index].capacity
    }
    storage_class_name               = data.terraform_remote_state.system.outputs.nfs_storage_class
    access_modes                     = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    persistent_volume_source {
      nfs {
        server = var.nfs_server
        path   = values(var.bazarr_nfs)[count.index].nfs_path
      }
    }
  }
}

resource kubernetes_persistent_volume_claim bazarr_nfs {
  count = length(var.bazarr_nfs)
  metadata {
    name      = values(var.bazarr_nfs)[count.index].name
    namespace = rancher2_namespace.bazarr.name
  }
  spec {
    storage_class_name = kubernetes_persistent_volume.bazarr_nfs[count.index].spec[0].storage_class_name
    access_modes       = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = values(var.bazarr_nfs)[count.index].capacity
      }
    }
    volume_name = kubernetes_persistent_volume.bazarr_nfs[count.index].metadata.0.name
  }
}

resource kubernetes_persistent_volume bazarr_iscsi {
  count = length(var.bazarr_iscsi)
  metadata {
    name = values(var.bazarr_iscsi)[count.index].name
  }
  spec {
    capacity = {
      storage = values(var.bazarr_iscsi)[count.index].capacity
    }
    storage_class_name               = "iscsi"
    access_modes                     = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    persistent_volume_source {
      iscsi {
        fs_type       = "ext4"
        iqn           = "${var.iscsi_iqn_base}:${values(var.bazarr_iscsi)[count.index].name}"
        lun           = values(var.bazarr_iscsi)[count.index].lun
        target_portal = var.iscsi_target
      }
    }
  }
}

resource kubernetes_persistent_volume_claim bazarr_iscsi {
  count = length(var.bazarr_iscsi)
  metadata {
    name      = values(var.bazarr_iscsi)[count.index].name
    namespace = rancher2_namespace.bazarr.name
  }
  spec {
    storage_class_name = kubernetes_persistent_volume.bazarr_iscsi[count.index].spec[0].storage_class_name
    access_modes       = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = kubernetes_persistent_volume.bazarr_iscsi[count.index].spec[0].capacity.storage
      }
    }
    volume_name = kubernetes_persistent_volume.bazarr_iscsi[count.index].metadata[0].name
  }
}

data template_file bazarr_values {
  template = file("${path.module}/templates/bazarr_values.yaml.tpl")
  vars = {
    process_uid        = var.process_uid
    process_gid        = var.process_gid
    ingress_class      = var.ingress_class
    certificate_issuer = var.certificate_issuer
    hostname           = "${var.bazarr_hostname}.${var.dns_domain}"
    pvc_config         = var.bazarr_iscsi.config.name
    pvc_tv             = var.bazarr_nfs.tv.name
    pvc_movies         = var.bazarr_nfs.movies.name
    node_selector      = yamlencode(var.vpn_node_selector)
  }
}

resource rancher2_app bazarr {
  name             = "bazarr"
  template_name    = "bazarr"
  catalog_name     = "${data.terraform_remote_state.cluster.outputs.cluster_id}:${data.rancher2_catalog.custom.name}"
  project_id       = data.rancher2_project.default.id
  target_namespace = rancher2_namespace.bazarr.name
  values_yaml      = base64encode(data.template_file.bazarr_values.rendered)

  depends_on = [
    kubernetes_persistent_volume_claim.bazarr_nfs,
    kubernetes_persistent_volume_claim.bazarr_iscsi,
  ]
}

resource dns_cname_record bazarr {
  zone  = "${var.dns_domain}."
  name  = var.bazarr_hostname
  cname = var.dns_ingress_a_record
  ttl   = 60
}
