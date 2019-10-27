/*terraform {
  backend "remote" {
    #hostname     = "app.terraform.io"
    organization = "xmple"
    workspaces {
      name = "k8s-apps"
    }
  }
}*/

resource local_file kube_config {
  sensitive_content = data.terraform_remote_state.cluster.outputs.kube_config
  filename          = "${path.module}/outputs/kubeconfig"
  file_permission   = "0600"
}