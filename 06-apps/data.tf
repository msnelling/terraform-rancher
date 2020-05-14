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

data rancher2_project system {
  cluster_id = local.cluster_id
  name       = "System"
}

data rancher2_project default {
  cluster_id = local.cluster_id
  name       = "Default"
}

data rancher2_catalog internal {
  name  = data.terraform_remote_state.cluster.outputs.internal_catalog
  scope = "cluster"
}

locals {
  cluster_id         = data.terraform_remote_state.cluster.outputs.cluster_id
  system_project_id  = data.rancher2_project.system.id
  default_project_id = data.rancher2_project.default.id
}