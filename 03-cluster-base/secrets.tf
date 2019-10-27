/***** cert-mananger
resource rancher2_secret cloudflare_api {
  name         = "cloudflare-api-key"
  project_id   = data.rancher2_project.system.id
  namespace_id = "cert-manager"
  data = {
    api-key = base64encode(var.cloudflare_api_key)
  }
}
*/

/***** consul
resource rancher2_secret consul_admin_auth {
  name       = "consul-admin-auth"
  project_id = data.rancher2_project.system.id
  data = {
    users = base64encode("${var.admin_username}:${bcrypt(var.admin_password, 11)}")
  }
}
*/