resource rancher2_secret cloudflare_api {
  name         = "cloudflare-api-key"
  project_id   = data.rancher2_project.system.id
  namespace_id = rancher2_namespace.cert_manager.id
  data = {
    api-key = base64encode(var.cloudflare_api_key)
  }
}
