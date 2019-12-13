terraform {
  backend "remote" {
    organization = "xmple"
    workspaces {
      name = "rancher"
    }
  }
}