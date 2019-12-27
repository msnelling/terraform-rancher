resource rancher2_project monitoring {
  name       = "Monitoring"
  cluster_id = data.terraform_remote_state.cluster.outputs.cluster_id
}