output kube_config {
  value     = rancher2_cluster_sync.cluster.kube_config
  sensitive = true
}

output cluster_id {
  value = rancher2_cluster_sync.cluster.id
}

output k8s_api_endpoint {
  value = local.k8s_api_endpoint
}

output k8s_api_token {
  value     = local.k8s_api_token
  sensitive = true
}
