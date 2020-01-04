data rancher2_namespace nginx_ingress {
  name       = "ingress-nginx"
  project_id = data.rancher2_project.system.id
}

resource rancher2_certificate ingress_tls {
  name         = "ingress-default-cert"
  namespace_id = data.rancher2_namespace.nginx_ingress.id
  project_id   = data.rancher2_project.system.id
  certs        = base64encode(acme_certificate.ingress_tls.certificate_pem)
  key          = base64encode(tls_private_key.ingress_tls.private_key_pem)
}

resource kubernetes_service nginx_ingress {
  metadata {
    name = "ingress-nginx"
    namespace = data.rancher2_namespace.nginx_ingress.name
    labels = {
      name = "ingress-nginx"
    }
  }
  
  spec {
    selector = {
      app = "ingress-nginx"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }

    port {
      name        = "https"
      port        = 443
      target_port = 443
      protocol    = "TCP"
    }

    type = "LoadBalancer"
    external_traffic_policy = "Local"
  }
}
