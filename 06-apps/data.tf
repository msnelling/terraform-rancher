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
      name = "k8s"
    }
  }
}

data terraform_remote_state system {
  backend = "remote"
  config = {
    organization = "xmple"
    workspaces = {
      name = "k8s-system"
    }
  }
}

data rancher2_project default {
  cluster_id = data.terraform_remote_state.cluster.outputs.cluster_id
  name       = "Default"
}
