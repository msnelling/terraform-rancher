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
    path = "${path.module}/../02-cluster/terraform.tfstate"
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

data template_file traefik_config {
  template = file("${path.module}/templates/traefik_config.yaml.tpl")
}
