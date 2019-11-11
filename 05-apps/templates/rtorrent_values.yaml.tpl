timezone: Europe/London
uid: ${process_uid}
gid: ${process_gid}
rtorrent:
  image:
    tag: latest
    pullPolicy: Always
flood:
  image:
    tag: latest
    pullPolicy: Always
ingress: 
  enabled: "true"
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-production
    kubernetes.io/ingress.class: nginx
  hosts:
    - rtorrent.k8s.xmple.io
  tls:
    - hosts:
      - rtorrent.k8s.xmple.io
      secretName: rtorrent-tls
persistence: 
  config: 
    existingClaim: ${pvc_config}
  data:
    existingClaim: ${pvc_data}
nodeSelector:
  ${node_selector}