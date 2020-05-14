installCRDs: true
global:
  leaderElection:
    namespace: cert-manager
image:
  pullPolicy: Always
webhook:
  image:
    pullPolicy: Always
cainjector:
  image:
    pullPolicy: Always
extraArgs:
  - --dns01-recursive-nameservers=1.1.1.1:53,1.0.0.1:53