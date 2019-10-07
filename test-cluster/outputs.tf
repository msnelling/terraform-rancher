output kube_config {
  value = "\n${rancher2_cluster.cluster.kube_config}"
}

output system_project_id {
  value = rancher2_cluster.cluster.system_project_id
}
