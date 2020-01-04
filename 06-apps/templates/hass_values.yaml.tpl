image: 
  tag: latest
  pullPolicy: Always
hostNetwork: true
ingress: 
  enabled: "true"
  annotations:
    cert-manager.io/cluster-issuer: ${certificate_issuer}
    kubernetes.io/ingress.class: ${ingress_class}
  hosts:
    - ${hostname}
  tls:
    - hosts:
      - ${hostname}
      secretName: hass-tls
persistence:
  existingClaim: ${pvc}