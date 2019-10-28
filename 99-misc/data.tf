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
