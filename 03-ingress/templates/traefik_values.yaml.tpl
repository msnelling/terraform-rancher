image:
  tag: v2.1
  pullPolicy: Always
logs:
  loglevel: INFO
#dashboard:
#  ingressRoute: true
additionalArguments:
  - --accesslog
#  - --providers.kubernetescrd.ingressclass=traefik
#  - --providers.kubernetescrd.namespaces=[]
  - --providers.kubernetesingress
  - --providers.kubernetesingress.ingressclass=traefik
#ports:
#  traefik:
#    expose: true
