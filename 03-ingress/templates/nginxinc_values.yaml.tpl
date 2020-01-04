controller:
  name: nginx-ingress
  healthStatus: true
  defaultTLS:
    secret: ${default_tls_secret}
  ingressClass: nginxinc
  useIngressClassOnly: true
  service:
    name: nginx-ingress
prometheus:
  create: true