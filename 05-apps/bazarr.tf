resource rancher2_namespace bazarr {
  name        = "bazarr"
  description = "Namespace for bazarr app components"
  project_id  = data.rancher2_project.default.id
}

resource kubernetes_persistent_volume bazarr {
  count = length(var.bazarr_nfs)
  metadata {
    name = values(var.bazarr_nfs)[count.index].name
  }
  spec {
    capacity = {
      storage = values(var.bazarr_nfs)[count.index].capacity
    }
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

resource kubernetes_persistent_volume_claim bazarr {
  count = length(var.bazarr_nfs)
  metadata {
    name      = values(var.bazarr_nfs)[count.index].name
    namespace = rancher2_namespace.bazarr.name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = values(var.bazarr_nfs)[count.index].capacity
      }
    }
    volume_name = kubernetes_persistent_volume.bazarr[count.index].metadata.0.name
  }
}

data template_file bazarr_values {
  template = file("${path.module}/templates/bazarr_values.yaml.tpl")
  vars = {
    process_uid   = var.process_uid
    process_gid   = var.process_gid
    hostname      = "${var.bazarr_hostname}.${var.dns_domain}"
    pvc_config    = var.bazarr_nfs.config.name
    node_selector = yamlencode(var.vpn_node_selector)
  }
}

resource rancher2_app bazarr {
  name             = "bazarr"
  catalog_name     = "${data.terraform_remote_state.cluster.outputs.cluster_id}:${rancher2_catalog.custom.name}"
  project_id       = data.rancher2_project.default.id
  target_namespace = rancher2_namespace.bazarr.name
  template_name    = "bazarr"
  values_yaml      = base64encode(data.template_file.bazarr_values.rendered)
}

resource dns_cname_record bazarr {
  zone  = "${var.dns_domain}."
  name  = var.bazarr_hostname
  cname = var.dns_ingress_a_record
  ttl   = 60
}
