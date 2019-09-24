###############################################################################
# Remote State
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "synchro"

    workspaces {
      name = "rancher"
    }
  }
}

###############################################################################
# vSphere
variable vsphere_server {}
variable vsphere_port {
  default = 443
}
variable vsphere_username {}
variable vsphere_password {}
variable vsphere_datacenter {
  default = "ha-datacenter"
}
variable vsphere_vm_network {
  default = "VM Network"
}
variable vsphere_aux_network {
  default = "Storage Network"
}
variable vsphere_vm_datastore {}
variable vsphere_iso_datastore {}

###############################################################################
# Docker
variable docker_registry {}

###############################################################################
# Rancher Server
variable rancher_hostname {}
variable rancher_domain {}
variable rancher_admin_password {}
variable rancher_iso_path {
  default = "Kits/ISO/rancheros-vmware.iso"
}

###############################################################################
# DNS
variable dns_servers {
  type = list(string)
}
variable dns_update_server {}
variable dns_update_key {}
variable dns_update_algorithm {}
variable dns_update_secret {}

###############################################################################
# Kubernetes Cluster
variable k8s_domain {}
variable k8s_cluster {
  default = [
    {
      name              = "k8s01"
      cpu_cores         = 1
      memory_mb         = 1500
      disk_gb           = 8
      address_cidr_ipv4 = "10.1.1.40/24"
      gateway_ipv4      = "10.1.1.1"
      roles             = ["etcd", "controlplane"]
      labels            = {}
    },
    {
      name              = "k8s02"
      cpu_cores         = 6
      memory_mb         = 2048
      disk_gb           = 8
      address_cidr_ipv4 = "10.1.1.41/24"
      gateway_ipv4      = "10.1.1.1"
      roles             = ["worker"]
      labels            = {}
    },
    {
      name              = "k8s03"
      cpu_cores         = 6
      memory_mb         = 2048
      disk_gb           = 8
      address_cidr_ipv4 = "10.1.1.42/24"
      gateway_ipv4      = "10.1.1.250"
      roles             = ["worker"]
      labels = {
        gateway = "vpn"
      }
    }
  ]
}