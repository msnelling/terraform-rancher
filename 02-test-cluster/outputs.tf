output kube_config {
  value     = rancher2_cluster.cluster.kube_config
  sensitive = true
}

output cluster_id {
  value = rancher2_cluster.cluster.id
}

output cluster_name {
  value = rancher2_cluster.cluster.name
}

output k8s_api_endpoint {
  value = yamldecode(rancher2_cluster.cluster.kube_config).clusters[0].cluster.server
}

output k8s_api_token {
  value     = yamldecode(rancher2_cluster.cluster.kube_config).users[0].user.token
  sensitive = true
}