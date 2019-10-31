image:
  tag: amd64-latest
  pullPolicy: Always
timezone: Europe/London
ingress: 
  enabled: "true"
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-production
    kubernetes.io/ingress.class: nginx
  hosts:
    - radarr.xmple.io
    - radarr.k8s.xmple.io
  tls:
    - hosts:
      - radarr.xmple.io
      - radarr.k8s.xmple.io
      secretName: radarr-tls
persistence: 
  config: 
    existingClaim: ${pvc_config}
  downloads:
    existingClaim: ${pvc_downloads}
  movies:
    existingClaim: ${pvc_media}