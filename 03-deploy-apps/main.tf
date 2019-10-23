/*terraform {
  backend "remote" {
    #hostname     = "app.terraform.io"
    organization = "xmple"
    workspaces {
      name = "k8s-apps"
    }
  }
}*/

/*
resource rancher2_catalog local {
  name        = "my-catalog"
  url         = "https://github.com/msnelling/terraform-rancher.git"
  description = "Temporary catalog hosting a Traefik v2.0 chart"
}
*/

resource local_file kube_config {
  sensitive_content = data.terraform_remote_state.cluster.outputs.kube_config
  filename          = "${path.module}/outputs/kubeconfig"
  file_permission   = "0600"
}
