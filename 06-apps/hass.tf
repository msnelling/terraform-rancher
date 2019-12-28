resource rancher2_namespace home_assistant {
  name        = "home-assistant"
  description = "Namespace for home-assistant app components"
  project_id  = data.rancher2_project.default.id
}

resource kubernetes_persistent_volume home_assistant_nfs {
  metadata {
    name = "home-assistant"
  }
  spec {
    capacity = {
      storage = "1Gi"
    }
    storage_class_name = data.terraform_remote_state.system.outputs.nfs_storage_class
    access_modes       = ["ReadWriteOnce"]
    persistent_volume_source {
      nfs {
        server = var.nfs_server
        path   = var.hass_nfs_path
      }
    }
  }
}

resource kubernetes_persistent_volume_claim home_assistant_nfs {
  metadata {
    name      = "home-assistant"
    namespace = rancher2_namespace.home_assistant.name
  }
  spec {
    storage_class_name = kubernetes_persistent_volume.home_assistant_nfs.spec[0].storage_class_name
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    volume_name = kubernetes_persistent_volume.home_assistant_nfs.metadata.0.name
  }
}

data template_file home_assistant_values {
  template = file("${path.module}/templates/hass_values.yaml.tpl")
  vars = {
    certificate_issuer = var.certificate_issuer
    hostname           = "${var.hass_hostname}.${var.dns_domain}"
    pvc                = kubernetes_persistent_volume.home_assistant_nfs.metadata.0.name
  }
}

resource rancher2_app home_assistant {
  name             = "home-assistant"
  template_name    = "home-assistant"
  catalog_name     = "helm"
  project_id       = data.rancher2_project.default.id
  target_namespace = rancher2_namespace.home_assistant.name
  values_yaml      = base64encode(data.template_file.home_assistant_values.rendered)

  depends_on = [
    kubernetes_persistent_volume_claim.nzbget_nfs,
  ]
}

resource dns_cname_record hass {
  zone  = "${var.dns_domain}."
  name  = var.hass_hostname
  cname = var.dns_ingress_a_record
  ttl   = 60
}
