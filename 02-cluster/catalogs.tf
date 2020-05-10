resource rancher2_catalog custom {
  name       = "xmple"
  url        = "https://xmple.github.io/charts/"
  scope      = "cluster"
  version    = "helm_v2"
  refresh    = true
  cluster_id = rancher2_cluster_sync.cluster.id
}
