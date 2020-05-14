output kube_config {
  value     = rancher2_cluster_sync.cluster.kube_config
  sensitive = true
}

output cluster_id {
  value = local.cluster_id
}

output k8s_api_endpoint {
  value = local.k8s_api_endpoint
}

output k8s_api_token {
  value     = local.k8s_api_token
  sensitive = true
}

output internal_catalog {
  value = rancher2_catalog.internal.name
}