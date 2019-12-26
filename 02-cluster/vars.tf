###############################################################################
# vSphere
variable vsphere_server {}
variable vsphere_username {}
variable vsphere_password {}
variable vsphere_datacenter {
  default = "ha-datacenter"
}
variable vsphere_pool {}
variable vsphere_vm_network {
  default = "VM Network"
}
variable vsphere_vm_datastore {}
variable vsphere_vm_template {}

###############################################################################
# GitHub
variable github_username {}

###############################################################################
# Docker
variable docker_registry {}

###############################################################################
# Rancher Server
variable rancher_iso_path {
  default = "Kits/ISO/rancheros-vmware.iso"
}
variable rancher_etcd_backup_s3_endpoint {}
variable rancher_etcd_backup_s3_region {
  default = ""
}
variable rancher_etcd_backup_s3_bucket {}
variable rancher_etcd_backup_s3_folder {
  default = ""
}
variable rancher_etcd_backup_s3_access_key {}
variable rancher_etcd_backup_s3_secret_key {}

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
variable k8s_ingress_provider {
  default = "nginx"
}
variable cluster {
  description = "List of VM specifications"
  type = list(object({
    name              = string       # VM name
    cpu_cores         = number       # VM number of cores
    memory_mb         = number       # VM memory in MB
    longhorn_disk_gb  = number       # VM disk capacity in GB
    address_cidr_ipv4 = string       # e.g "10.1.1.41/24"
    gateway_ipv4      = string       # e.g. "10.1.1.1"
    roles             = list(string) # e.g. ["etcd", "controlplane", "worker"]
    labels            = map(string)  # e.g. {gateway = "vpn"}
  }))
  default = [
    {
      name              = "k8s01"
      cpu_cores         = 6
      memory_mb         = 4096
      longhorn_disk_gb  = 32
      address_cidr_ipv4 = "10.1.1.41/24"
      gateway_ipv4      = "10.1.1.1"
      roles             = ["etcd", "controlplane", "worker"]
      labels            = {}
    },
    {
      name              = "k8s02"
      cpu_cores         = 6
      memory_mb         = 4096
      longhorn_disk_gb  = 32
      address_cidr_ipv4 = "10.1.1.42/24"
      gateway_ipv4      = "10.1.1.250"
      roles             = ["etcd", "controlplane", "worker"]
      labels = {
        gateway = "vpn"
      }
    },
    {
      name              = "k8s03"
      cpu_cores         = 6
      memory_mb         = 4096
      longhorn_disk_gb  = 32
      address_cidr_ipv4 = "10.1.1.43/24"
      gateway_ipv4      = "10.1.1.250"
      roles             = ["etcd", "controlplane", "worker"]
      labels = {
        gateway = "vpn"
      }
    }
  ]
}