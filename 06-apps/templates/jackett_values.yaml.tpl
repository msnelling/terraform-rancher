image:
  tag: amd64-latest
  pullPolicy: Always
timezone: Europe/London
puid: ${process_uid}
pgid: ${process_gid}
ingress: 
  enabled: "true"
  annotations:
    cert-manager.io/cluster-issuer: ${certificate_issuer}
    kubernetes.io/ingress.class: ${ingress_class}
    traefik.ingress.kubernetes.io/router.entrypoints: websecure
    traefik.ingress.kubernetes.io/router.tls: "true"
  hosts:
    - ${hostname}
  tls:
    - hosts:
      - ${hostname}
      secretName: jackett-tls
persistence: 
  config: 
    existingClaim: ${pvc_config}
  downloads:
    existingClaim: ${pvc_downloads}
nodeSelector:
  ${node_selector}
