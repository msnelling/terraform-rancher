terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "synchro"

    workspaces {
      name = "rancher"
    }
  }
}

variable "vsphere_server" {}
variable "vsphere_port" {
  default = 443
}
variable "vsphere_username" {}
variable "vsphere_password" {}
variable "vsphere_datacenter" {
  default = "ha-datacenter"
}
variable "vsphere_vm_network" {
  default = "VM Network"
}
variable "vsphere_storage_network" {
  default = "Storage Network"
}
variable "vsphere_vm_datastore" {}
variable "vsphere_iso_datastore" {}

variable "rancher_hostname" {}
variable "rancher_domain" {}
variable "rancher_admin_password" {}
variable "rancher_iso_path" {
  default = "Kits/ISO/rancheros-vmware.iso"
}
variable "rancher_eth0_address_cidr" {}

variable "dns_servers" {
  type = list(string)
}
variable "dns_update_server" {}
variable "dns_update_key" {}
variable "dns_update_algorithm" {}
variable "dns_update_secret" {}

variable k8s_domain {}
variable k8s_master_hostname {
  default = "k8s-master"
}

variable k8s_cluster {
  default = [
    {
      name         = "k8s01"
      cpu_cores    = 2
      memory       = 2048
      ipv4_address = "10.1.1.40"
      roles        = ["etcd", "controlplane"]
    },
    {
      name         = "k8s02"
      cpu_cores    = 2
      memory       = 2048
      ipv4_address = "10.1.1.41"
      roles        = ["worker"]
    },
    {
      name         = "k8s03"
      cpu_cores    = 2
      memory       = 2048
      ipv4_address = "10.1.1.42"
      roles        = ["worker"]
    }
  ]
}