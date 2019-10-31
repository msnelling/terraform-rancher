resource rancher2_catalog bilimek {
  name       = "bilimek"
  url        = "https://billimek.com/billimek-charts/"
  scope      = "cluster"
  cluster_id = data.terraform_remote_state.cluster.outputs.cluster_id
}
