terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "xmple"

    workspaces {
      name = "rancher"
    }
  }
}
