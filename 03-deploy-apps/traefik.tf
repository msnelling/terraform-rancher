resource rancher2_namespace traefik_ingress {
  name       = "traefik-ingress"
  project_id = data.rancher2_project.system.id
}

resource rancher2_app traefik_ingress {
  catalog_name     = "my-catalog"
  name             = "traefik"
  project_id       = data.rancher2_project.system.id
  target_namespace = rancher2_namespace.traefik_ingress.name
  template_name    = "traefik"
  force_upgrade    = true
  values_yaml      = <<EOF
dashboard:
  enabled: true
  hostname: ${var.traefik_dashboard_hostname}
  htpasswd: |
    ${var.admin_username}:${local.traefik_password}
acme: 
  dnsProvider: 
    cloudflare: 
      CLOUDFLARE_API_KEY: ${var.cloudflare_api_key}
      CLOUDFLARE_EMAIL: ${var.cloudflare_api_email}
    name: cloudflare
  persistence: 
    storageClass: nfs-client
EOF

  depends_on = [rancher2_app.nfs_client_provisioner]
  count = 0
}
