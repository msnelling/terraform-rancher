global:
  sendAnonymousUsage: true
api:
  insecure: true
  dashboard: true
ping: {} # Enable with defaults
#metrics:
#  prometheus: {} # Enable with defaults
#  influxDB:
#    address: localhost:8089
#    protocol: udp
log:
  level: INFO
accessLog: {} # Enable with defaults
entryPoints:
  web:
    address: :80
  websecure:
    address: :443
forwardedHeaders:
  insecure: true
providers:
  kubernetesCRD:
    ingressClass: traefik
    namespaces: [] # All namespaces
  kubernetesIngress:
    ingressClass: traefik
    namespaces: [] # All namespaces
certificatesResolvers:
  default:
    acme:
      storage: /acme/acme.json
      caServer: https://acme-staging-v02.api.letsencrypt.org/directory
      dnsChallenge:
        provider: cloudflare
        delayBeforeCheck: 0
        resolvers:
          - 1.1.1.1:53
          - 1.0.0.1:53
tls:
  options:
    default:
      minVersion: VersionTLS12
#  stores:
#    default:
#      defaultCertificate:
#        certFile: path/to/cert.crt
#        keyFile: path/to/cert.key
#      clientAuth:
#        caFiles:
#          - tests/clientca1.crt
#        clientAuthType: RequireAndVerifyClientCert
#  certificates:
#    - certFile: /path/to/domain.cert
#      keyFile: /path/to/domain.key
#      stores:
#        - default
#    # Note that since no store is defined,
#    # the certificate below will be stored in the `default` store.
#    - certFile: /path/to/other-domain.cert
#      keyFile: /path/to/other-domain.key
