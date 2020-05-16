clusterIssuers:
  - name: letsencrypt-production
    acme:
      email: ${acme_email}
      server: https://acme-v02.api.letsencrypt.org/directory
      privateKeySecret: letsencrypt-production-account-key
    dnsSolvers:
      cloudflare:
        email: ${cloudflare_email}
        apiKeySecretRef:
          name: cloudflare-api-key
          key: api-key
  - name: letsencrypt-staging
    acme:
      email: ${acme_email}
      server: https://acme-staging-v02.api.letsencrypt.org/directory
      privateKeySecret: letsencrypt-staging-account-key
    dnsSolvers:
      cloudflare:
        email: ${cloudflare_email}
        apiKeySecretRef:
          name: cloudflare-api-key
          key: api-key