timezone: Europe/London
uid: ${process_uid}
gid: ${process_gid}
image:
  tag: latest
  pullPolicy: Always
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
      secretName: qbittorrent-tls
persistence: 
  config: 
    existingClaim: ${pvc_config}
  data:
    existingClaim: ${pvc_data}
nodeSelector:
  ${node_selector}