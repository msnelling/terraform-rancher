grafana:
  image:
    tag: latest
    pullPolicy: Always
  enabled: true
  ingress:
    enabled: true
    annotations:
      #cert-manager.io/cluster-issuer: letsencrypt-production
      kubernetes.io/ingress.class: ${ingress_class}
    hosts:
      - ${hostname}
    tls:
      - hosts:
        - ${hostname}
        #secretName: loki-tls