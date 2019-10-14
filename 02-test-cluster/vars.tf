###############################################################################
# vSphere
variable vsphere_server {}
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
variable k8s_name {}
variable k8s_domain {}
variable k8s_cluster {
  default = [
    {
      name              = "k8s01"
      cpu_cores         = 6
      cpu_limit         = 500
      memory_mb         = 4096
      disk_gb           = 16
      address_cidr_ipv4 = "10.1.1.40/24"
      gateway_ipv4      = "10.1.1.1"
      roles             = ["etcd", "controlplane", "worker"]
      labels            = {}
    },
    {
      name              = "k8s02"
      cpu_cores         = 6
      cpu_limit         = 500
      memory_mb         = 4096
      disk_gb           = 16
      address_cidr_ipv4 = "10.1.1.41/24"
      gateway_ipv4      = "10.1.1.1"
      roles             = ["etcd", "controlplane", "worker"]
      labels            = {}
    },
    {
      name              = "k8s03"
      cpu_cores         = 6
      cpu_limit         = 500
      memory_mb         = 4096
      disk_gb           = 16
      address_cidr_ipv4 = "10.1.1.42/24"
      gateway_ipv4      = "10.1.1.250"
      roles             = ["etcd", "controlplane", "worker"]
      labels = {
        gateway = "vpn"
      }
    }
  ]
}