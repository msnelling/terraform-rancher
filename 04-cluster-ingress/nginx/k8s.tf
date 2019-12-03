resource kubernetes_service ingress {
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
