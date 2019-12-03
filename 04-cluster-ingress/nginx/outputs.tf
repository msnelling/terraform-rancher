output ingress_ips {
  value = kubernetes_service.ingress.load_balancer_ingress.*.ip
}