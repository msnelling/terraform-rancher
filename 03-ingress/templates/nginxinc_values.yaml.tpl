controller:
  ingressClass: nginx-helm
  useIngressClassOnly: true
  healthStatus: true
  defaultTLS:
    secret: ${default_tls_secret}
  service:
    name: nginx-ingress
prometheus:
  create: true