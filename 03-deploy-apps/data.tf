data terraform_remote_state rancher {
  backend = "remote"

  config = {
    organization = "xmple"
    workspaces = {
      name = "rancher"
    }
  }
}

data terraform_remote_state cluster {
  backend = "remote"

  config = {
    organization = "xmple"
    workspaces = {
      name = "k8s-test"
    }
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
    "${data.terraform_remote_state.rancher.outputs.api_url}/v3/catalogs/${rancher2_catalog.local.name}?action=refresh"
  ]
}
