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
    cert-manager.io/cluster-issuer: ${certificate_issuer}
    kubernetes.io/ingress.class: nginx
  hosts:
    - ${hostname}
  tls:
    - hosts:
      - ${hostname}
      secretName: bazarr-tls
persistence: 
  config: 
    existingClaim: ${pvc_config}
  tv:
    existingClaim: ${pvc_tv}
  movies:
    existingClaim: ${pvc_movies}
nodeSelector:
  ${node_selector}
