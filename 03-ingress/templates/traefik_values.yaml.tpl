logs:
  loglevel: INFO
additionalArguments:
  - --accesslog
  - --providers.kubernetescrd.ingressclass=traefik
  - --providers.kubernetesingress
  - --providers.kubernetesingress.ingressclass=traefik