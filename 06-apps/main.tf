terraform {
  backend "remote" {
    organization = "xmple"
    workspaces {
      name = "k8s-apps"
    }
  }
}