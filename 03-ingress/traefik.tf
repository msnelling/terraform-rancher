resource rancher2_catalog traefik {
  name       = "traefik"
  url        = "https://containous.github.io/traefik-helm-chart"
  scope      = "cluster"
  cluster_id = local.cluster_id
  version    = "helm_v3"
  refresh    = true
}

resource rancher2_namespace traefik {
  name       = "traefik"
  project_id = local.system_project_id
}

resource rancher2_app traefik {
  name             = "traefik"
  template_name    = "traefik"
  catalog_name     = "${local.cluster_id}:${rancher2_catalog.traefik.name}"
  project_id       = local.system_project_id
  target_namespace = rancher2_namespace.traefik.name
  values_yaml      = base64encode(templatefile("${path.module}/templates/traefik_values.yaml.tpl", {}))
}

data kubernetes_service traefik {
  metadata {
    name      = "traefik"
    namespace = rancher2_namespace.traefik.name
  }

  depends_on = [rancher2_app.traefik]
}

/*
resource kubernetes_ingress traefik_ingress {
  metadata {
    name      = "traefik"
    namespace = rancher2_namespace.traefik.name
    annotations = {
      "kubernetes.io/ingress.class" = "traefik"
    }
  }

  spec {
    rule {
      host = "traefik.k8s.xmple.io"
      http {
        path {
          backend {
            service_name = "traefik"
            service_port = "traefik"
          }
        }
      }
    }
    tls {
      hosts = ["traefik.k8s.xmple.io"]
    }
  }
}
*/

resource dns_a_record_set traefik_ingress {
  zone      = "${var.ingress_domain}."
  name      = var.traefik_ingress_hostname
  addresses = data.kubernetes_service.traefik.load_balancer_ingress.*.ip
  ttl       = 60
}
