resource "rancher2_catalog" "certmanager" {
  name       = "cert-manager"
  url        = "https://charts.jetstack.io"
  scope      = "cluster"
  cluster_id = data.terraform_remote_state.cluster.outputs.cluster_id
}

resource rancher2_namespace certmanager {
  name        = "cert-manager"
  description = "Namespace for cert-manager components"
  project_id  = data.rancher2_project.system.id
}
