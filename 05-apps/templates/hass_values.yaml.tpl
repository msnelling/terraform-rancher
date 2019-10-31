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
    - hass.xmple.io
    - hass.k8s.xmple.io
  tls:
    - hosts:
      - hass.xmple.io
      - hass.k8s.xmple.io
      secretName: hass-tls
persistence:
  existingClaim: ${pvc}