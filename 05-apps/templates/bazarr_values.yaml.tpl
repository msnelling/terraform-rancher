image:
  tag: amd64-latest
  pullPolicy: Always
puid: ${process_uid}
pgid: ${process_gid}
umask: "0077"
timezone: Europe/London
ingress: 
  enabled: "true"
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-production
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
nodeSelector:
  ${node_selector}
