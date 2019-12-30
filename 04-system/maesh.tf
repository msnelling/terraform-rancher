resource rancher2_namespace maesh {
  name        = "maesh"
  description = "Namespace for Maesh networking"
  project_id  = data.rancher2_project.system.id
}

resource rancher2_catalog maesh {
  name       = "maesh"
  url        = "https://containous.github.io/maesh/charts"
  scope      = "cluster"
  cluster_id = data.terraform_remote_state.cluster.outputs.cluster_id
}

data template_file maesh_values {
  template = file("${path.module}/templates/maesh_values.yaml.tpl")
  vars = {
    #hostname = "${var.maesh_hostname}.${var.maesh_domain}"
  }
}

resource rancher2_app maesh {
  name             = "maesh"
  template_name    = "maesh"
  catalog_name     = "${data.terraform_remote_state.cluster.outputs.cluster_id}:${rancher2_catalog.maesh.name}"
  project_id       = data.rancher2_project.system.id
  target_namespace = rancher2_namespace.maesh.name
  values_yaml      = base64encode(data.template_file.maesh_values.rendered)
}

/*
resource kubernetes_service jaeger {
  metadata {
    name      = "jaeger-ui"
    namespace = rancher2_namespace.maesh.name
  }

  spec {
    selector = {
      "app.kubernetes.io/name"      = "jaeger"
      "app.kubernetes.io/component" = "all-in-one"
    }

    port {
      name = "http"
      port = 16686
    }

    type = "ClusterIP"
  }
}

resource kubernetes_ingress jaeger {
  metadata {
    name      = "jaeger"
    namespace = rancher2_namespace.maesh.name

    annotations = {
      "cert-manager.io/cluster-issuer" = "letsencrypt-production"
      "kubernetes.io/ingress.class"    = "nginx"
    }
  }

  spec {
    rule {
      host = "${var.jaeger_hostname}.${var.jaeger_domain}"

      http {
        path {
          backend {
            service_name = "jaeger-ui"
            service_port = "http"
          }
        }
      }
    }

    tls {
      hosts = [
        "${var.jaeger_hostname}.${var.jaeger_domain}"
      ]
    }
  }
}

resource dns_cname_record maesh {
  zone  = "${var.jaeger_domain}."
  name  = var.jaeger_hostname
  cname = "${data.terraform_remote_state.ingress.outputs.ingress_fqdn}."
  ttl   = 60
}
*/