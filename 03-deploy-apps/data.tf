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