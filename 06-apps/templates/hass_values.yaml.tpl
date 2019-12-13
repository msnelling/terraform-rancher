image: 
  tag: latest
  pullPolicy: Always
hostNetwork: true
ingress: 
  enabled: true
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-production
    kubernetes.io/ingress.class: nginx
  hosts:
    - ${hostname}
  tls:
    - hosts:
      - ${hostname}
      secretName: hass-tls
persistence:
  existingClaim: ${pvc}