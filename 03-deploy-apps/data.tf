data terraform_remote_state rancher {
  #  backend = "remote"
  backend = "local"
  config = {
    #    organization = "xmple"
    #    workspaces = {
    #      name = "rancher"
    #    }
    path = "${path.module}/../01-rancher-server/terraform.tfstate"
  }
}

data terraform_remote_state cluster {
  #  backend = "remote"
  backend = "local"
  config = {
    #    organization = "xmple"
    #    workspaces = {
    #      name = "k8s"
    #    }
    path = "${path.module}/../02-test-cluster/terraform.tfstate"
  }
}

data rancher2_project system {
  cluster_id = data.terraform_remote_state.cluster.outputs.cluster_id
  name       = "System"
}

data rancher2_project default {
  cluster_id = data.terraform_remote_state.cluster.outputs.cluster_id
  name       = "Default"
}

data external catalog_refresh {
  program = [
    "curl",
    "--fail",
    "-H", "Authorization: Bearer ${data.terraform_remote_state.rancher.outputs.token_key}",
    "-X", "POST",
    "${data.terraform_remote_state.rancher.outputs.api_url}/v3/catalogs/${rancher2_catalog.traefik.name}?action=refresh"
  ]

  depends_on = [rancher2_catalog.traefik]
}

/***** cert-mananger
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

data template_file traefik_config {
  template = file("${path.module}/templates/traefik_config.yaml.tpl")
}
