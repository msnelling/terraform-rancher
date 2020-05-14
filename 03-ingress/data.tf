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

data rancher2_project system {
  cluster_id = data.terraform_remote_state.cluster.outputs.cluster_id
  name       = "System"
}

locals {
  cluster_id           = data.terraform_remote_state.cluster.outputs.cluster_id
  system_project_id    = data.rancher2_project.system.id
}