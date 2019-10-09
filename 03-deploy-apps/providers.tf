provider rancher2 {
  api_url   = data.terraform_remote_state.rancher.outputs.api_url
  token_key = data.terraform_remote_state.rancher.outputs.token_key
}

provider kubernetes {
  host  = data.terraform_remote_state.cluster.k8s_api_endpoint
  token = data.terraform_remote_state.cluster.k8s_api_token
}