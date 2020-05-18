image:
  tag: v2.2
  pullPolicy: Always
logs:
  loglevel: ERROR
additionalArguments:
  - --log
  - --log.level=INFO
  - --accesslog
  - --providers.kubernetesingress.ingressclass=traefik
  - --entryPoints.websecure.http.tls=true
ports:
  traefik:
    expose: true