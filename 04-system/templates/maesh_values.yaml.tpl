controller:
  image:
    name: containous/maesh
    tag: latest
    pullPolicy: Always
  ignoreNamespaces:
    - nfs-client-provisioner
mesh:
  image:
    name: traefik
    tag: latest
    pullPolicy: Always
tracing:
  jaeger:
    enabled: false
metrics:
  deploy: false
smi:
  enable: false