resource rancher2_namespace traefik_ingress {
  name       = "traefik-ingress"
  project_id = data.rancher2_project.system.id
}

resource rancher2_app traefik_ingress {
  catalog_name     = "my-catalog"
  name             = "traefikv2"
  project_id       = data.rancher2_project.system.id
  target_namespace = rancher2_namespace.traefik_ingress.name
  template_name    = "traefikv2"
  template_version = "0.1.14"
  values_yaml      = <<EOF
acme: 
  dnsProvider: 
    cloudflare: 
      CLOUDFLARE_API_KEY: ${var.cloudflare_api_key}
      CLOUDFLARE_EMAIL: ${var.cloudflare_api_email}
    name: cloudflare
  persistence: 
    storageClass: nfs-client
EOF
}
