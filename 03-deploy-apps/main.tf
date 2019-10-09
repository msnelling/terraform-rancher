terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "xmple"

    workspaces {
      name = "k8s-test-apps"
    }
  }
}

resource "rancher2_catalog" "local" {
  name        = "my-catalog"
  url         = "https://github.com/msnelling/terraform-rancher.git"
  description = "Temporary catalog hosting a Traefik v2.0 chart"
}
