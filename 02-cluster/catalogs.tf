resource rancher2_catalog internal {
  name       = "xmple"
  url        = "https://xmple.github.io/charts/"
  version    = "helm_v2"
  scope      = "cluster"
  cluster_id = local.cluster_id
  refresh    = true
}
