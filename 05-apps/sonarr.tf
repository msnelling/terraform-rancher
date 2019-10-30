resource rancher2_namespace sonarr {
  name        = "sonarr"
  description = "Namespace for sonarr app components"
  project_id  = data.rancher2_project.default.id
}

resource kubernetes_persistent_volume sonarr_config {
  count = length(var.sonarr_nfs_paths)
  metadata {
    name = var.sonarr_nfs_paths[count.index].name
  }
  spec {
    capacity = {
      storage = var.sonarr_nfs_paths[count.index].capacity
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_source {
      nfs {
        server = var.nfs_server
        path   = var.sonarr_nfs_paths[count.index].nfs_path
      }
    }
  }
}

resource kubernetes_persistent_volume_claim sonarr_config {
  count = length(var.sonarr_nfs_paths)
  metadata {
    name      = var.sonarr_nfs_paths[count.index].name
    namespace = rancher2_namespace.sonarr.name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.sonarr_nfs_paths[count.index].capacity
      }
    }
    volume_name = kubernetes_persistent_volume.sonarr_config[count.index].metadata.0.name
  }
}

data template_file sonarr_values {
  template = file("${path.module}/templates/sonarr_values.yaml.tpl")
  vars = {
    pvc_config = kubernetes_persistent_volume.sonarr_config.0.metadata.0.name
    pvc_downloads= kubernetes_persistent_volume.sonarr_config.1.metadata.0.name
    pvc_tv = kubernetes_persistent_volume.sonarr_config.2.metadata.0.name
  }
}

resource rancher2_catalog bilimek {
  name       = "bilimek"
  url        = "https://billimek.com/billimek-charts/"
  scope      = "cluster"
  cluster_id = data.terraform_remote_state.cluster.outputs.cluster_id
}

resource rancher2_app sonarr {
  name             = "sonarr"
  catalog_name     = "${data.terraform_remote_state.cluster.outputs.cluster_id}:${rancher2_catalog.bilimek.name}"
  project_id       = data.rancher2_project.default.id
  target_namespace = rancher2_namespace.sonarr.name
  template_name    = "sonarr"
  values_yaml      = base64encode(data.template_file.sonarr_values.rendered)
}
