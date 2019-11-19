resource rancher2_namespace nzbget {
  name        = "nzbget"
  description = "Namespace for nzbget app components"
  project_id  = data.rancher2_project.default.id
}

resource kubernetes_persistent_volume nzbget {
  count = length(var.nzbget_nfs)
  metadata {
    name = values(var.nzbget_nfs)[count.index].name
  }
  spec {
    capacity = {
      storage = values(var.nzbget_nfs)[count.index].capacity
    }
    access_modes                     = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    persistent_volume_source {
      nfs {
        server = var.nfs_server
        path   = values(var.nzbget_nfs)[count.index].nfs_path
      }
    }
  }
}

resource kubernetes_persistent_volume_claim nzbget {
  count = length(var.nzbget_nfs)
  metadata {
    name      = values(var.nzbget_nfs)[count.index].name
    namespace = rancher2_namespace.nzbget.name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = values(var.nzbget_nfs)[count.index].capacity
      }
    }
    volume_name = kubernetes_persistent_volume.nzbget[count.index].metadata.0.name
  }
}

data template_file nzbget_values {
  template = file("${path.module}/templates/nzbget_values.yaml.tpl")
  vars = {
    process_uid   = var.process_uid
    process_gid   = var.process_gid
    hostname      = "${var.nzbget_hostname}.${var.dns_domain}"
    pvc_config    = var.nzbget_nfs.config.name
    pvc_downloads = var.nzbget_nfs.downloads.name
    node_selector = yamlencode(var.vpn_node_selector)
  }
}

resource rancher2_app nzbget {
  name             = "nzbget"
  catalog_name     = "${data.terraform_remote_state.cluster.outputs.cluster_id}:${rancher2_catalog.custom.name}"
  project_id       = data.rancher2_project.default.id
  target_namespace = rancher2_namespace.nzbget.name
  template_name    = "nzbget"
  values_yaml      = base64encode(data.template_file.nzbget_values.rendered)
}

resource dns_cname_record nzbget {
  zone  = "${var.dns_domain}."
  name  = var.nzbget_hostname
  cname = var.dns_ingress_a_record
  ttl   = 60
}
