output kube_config {
  value     = rancher2_cluster.cluster.kube_config
  sensitive = true
}

output cluster_id {
  value = rancher2_cluster.cluster.id
}

output k8s_api_endpoint {
  value = local.k8s_api_endpoint
}

output k8s_api_token {
  value     = local.k8s_api_token
  sensitive = true
}

output ingress_type {
  value = var.k8s_ingress_provider
}