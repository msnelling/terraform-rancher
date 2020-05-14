resource rancher2_catalog jetstack {
  name       = "jetstack"
  url        = "https://charts.jetstack.io"
  version    = "helm_v2"
  scope      = "cluster"
  cluster_id = local.cluster_id
  refresh    = true
}

resource rancher2_namespace cert_manager {
  name       = "cert-manager"
  project_id = local.system_project_id
}

resource rancher2_app cert_manager {
  name             = "cert-manager"
  template_name    = "cert-manager"
  template_version = "v${var.cert_manager_version}"
  catalog_name     = "${local.cluster_id}:${rancher2_catalog.jetstack.name}"
  project_id       = local.system_project_id
  target_namespace = rancher2_namespace.cert_manager.name
  values_yaml      = base64encode(templatefile("${path.module}/templates/cert_manager_values.yaml.tpl", {}))
}

/*
data template_file cert_manager_staging_issuer {
  template = file("${path.module}/templates/cloudflare_issuer.yaml.tpl")
  vars = {
    issuer_name          = "letsencrypt-staging"
    acme_ca_server       = "https://acme-staging-v02.api.letsencrypt.org/directory"
    acme_email           = var.acme_email
    cloudflare_api_email = var.cloudflare_api_email
  }
}

data template_file cert_manager_production_issuer {
  template = file("${path.module}/templates/cloudflare_issuer.yaml.tpl")
  vars = {
    issuer_name          = "letsencrypt-production"
    acme_ca_server       = "https://acme-v02.api.letsencrypt.org/directory"
    acme_email           = var.acme_email
    cloudflare_api_email = var.cloudflare_api_email
  }
}
*/

/*
module install_staging_issuer {
  source = "../modules/kubernetes_manifest"
  manifest_yaml = data.template_file.cert_manager_staging_issuer.rendered
}

module install_production_issuer {
  source = "../modules/kubernetes_manifest"
  manifest_yaml = data.template_file.cert_manager_production_issuer.rendered
}
*/