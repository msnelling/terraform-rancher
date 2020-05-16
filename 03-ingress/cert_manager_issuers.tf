resource rancher2_secret cloudflare_api {
  name         = "cloudflare-api-key"
  project_id   = data.rancher2_project.system.id
  namespace_id = rancher2_namespace.cert_manager.id
  data = {
    api-key = base64encode(var.cloudflare_api_key)
  }
}

resource helm_release letsencrypt_issuer {
  name         = "cert-manager-issuer"
  chart        = "cert-manager-issuer"
  repository   = "https://xmple.github.io/charts/"
  force_update = true
  values = [
    templatefile("${path.module}/templates/issuer_values.yaml.tpl", {
      acme_email       = var.acme_email
      cloudflare_email = var.cloudflare_api_email
    })
  ]
}