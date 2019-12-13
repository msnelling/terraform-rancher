data terraform_remote_state rancher {
  backend = "remote"
  config = {
    organization = "xmple"
    workspaces = {
      name = "rancher"
    }
  }
  #  backend = "local"
  #  config = {
  #    path    = "${path.module}/../01-rancher-server/terraform.tfstate"
  #  }
}

data terraform_remote_state cluster {
  backend = "remote"
  config = {
    organization = "xmple"
    workspaces = {
      name = "k8s"
    }
  }
  #  backend = "local"
  #  config = {
  #    path    = "${path.module}/../02-cluster/terraform.tfstate"
  #  }
}

data terraform_remote_state ingress {
  backend = "remote"
  config = {
    organization = "xmple"
    workspaces = {
      name = "k8s-ingress"
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
