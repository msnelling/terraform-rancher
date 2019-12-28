image:
  tag: amd64-latest
  pullPolicy: Always
timezone: Europe/London
puid: ${process_uid}
pgid: ${process_gid}
umask: "0077"
ingress: 
  enabled: "true"
  annotations:
    cert-manager.io/cluster-issuer: ${certificate_issuer}
    kubernetes.io/ingress.class: nginx
  hosts:
    - ${hostname}
  tls:
    - hosts:
      - ${hostname}
      secretName: sonarr-tls
persistence: 
  config: 
    existingClaim: ${pvc_config}
  downloads:
    existingClaim: ${pvc_downloads}
  tv:
    existingClaim: ${pvc_media}
nodeSelector:
  ${node_selector}
