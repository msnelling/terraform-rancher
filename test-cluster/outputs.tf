output kube_config {
  value     = "${rancher2_cluster.cluster.kube_config}"
  sensitive = true
}

output system_project_id {
  value = rancher2_cluster.cluster.system_project_id
}
