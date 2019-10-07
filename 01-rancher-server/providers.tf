provider vsphere {
  vsphere_server       = var.vsphere_server
  user                 = var.vsphere_username
  password             = var.vsphere_password
  allow_unverified_ssl = true
}

provider dns {
  update {
    server        = var.dns_update_server
    key_name      = var.dns_update_key
    key_algorithm = var.dns_update_algorithm
    key_secret    = var.dns_update_secret
  }
}

provider rancher2 {
  alias     = "bootstrap"
  api_url   = "https://${var.rancher_hostname}.${var.rancher_domain}"
  bootstrap = true
  insecure  = true
}

provider rancher2 {
  api_url   = rancher2_bootstrap.admin.url
  token_key = rancher2_bootstrap.admin.token
  insecure  = true
}
