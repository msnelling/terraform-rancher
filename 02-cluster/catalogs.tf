resource rancher2_catalog internal {
  name       = "xmple"
  url        = "https://xmple.github.io/charts/"
  scope      = "cluster"
  version    = "helm_v2"
  refresh    = true
  cluster_id = local.cluster_id
}
