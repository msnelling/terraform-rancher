apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: ${issuer_name}
spec:
  acme:
    email: ${acme_email}
    server: ${acme_ca_server}
    privateKeySecretRef:
      name: staging-issuer-account-key
    solvers:
      - dns01:
          cloudflare:
            email: ${cloudflare_api_email}
            apiKeySecretRef:
                name: cloudflare-api-key
                key: api-key