terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "synchro"

    workspaces {
      name = "rancher"
    }
  }
}

variable "rancher_hostname" {}
variable "rancher_domain" {}
variable "rancher_admin_password" {}
variable "vsphere_server" {}
variable "vsphere_port" {
  default = 443
}
variable "vsphere_username" {}
variable "vsphere_password" {}
variable "vsphere_datacenter" {
  default = "ha-datacenter"
}

variable "rancher_vm_network" {
  default = "VM Network"
}
variable "rancher_vm_datastore" {}
variable "rancher_iso_datastore" {}
variable "rancher_iso_path" {
  default = "Kits/ISO/rancheros-vmware.iso"
}
variable "rancher_dns_servers" {
  type = list(string)
}
variable "rancher_eth0_address_cidr" {}
variable "dns_update_server" {}
variable "dns_update_key" {}
variable "dns_update_algorithm" {}
variable "dns_update_secret" {}
