image:
  tag: amd64-latest
  pullPolicy: Always
puid: ${process_uid}
pgid: ${process_gid}
timezone: Europe/London
ingress: 
  enabled: "true"
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-production
    kubernetes.io/ingress.class: nginx
  hosts:
    - sonarr.xmple.io
    - sonarr.k8s.xmple.io
  tls:
    - hosts:
      - sonarr.xmple.io
      - sonarr.k8s.xmple.io
      secretName: sonarr-tls
persistence: 
  config: 
    existingClaim: ${pvc_config}
  downloads:
    existingClaim: ${pvc_downloads}
  tv:
    existingClaim: ${pvc_media}