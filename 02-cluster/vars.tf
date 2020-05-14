###############################################################################
# vSphere
variable vsphere_server {}
variable vsphere_username {}
variable vsphere_password {}
variable vsphere_datacenter {
  default = "Datacenter"
}
variable vsphere_pool {}
variable vsphere_vm_network {
  default = "DPortGroup"
}
variable vsphere_vm_datastore {}
variable vsphere_vm_template {}

###############################################################################
# Admin user
variable admin_user {}
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
# Addons
variable cert_manager_version {
  default = "0.15.0"
}
variable metallb_version {
  default = "0.9.3"
}

###############################################################################
# Metal-LB
variable metallb_address_pool {}

###############################################################################
# Kubernetes Cluster
variable k8s_name {}
variable k8s_domain {}
variable k8s_version {
  default = "v1.17.5-rancher1-1"
}
variable k8s_ingress_provider {
  default = "nginx"
}
variable cluster {
  description = "List of VM specifications"
  type = list(object({
    name             = string       # VM name
    cpu_cores        = number       # VM number of cores
    memory_mb        = number       # VM memory in MB
    longhorn_disk_gb = number       # VM disk capacity in GB
    interface        = string       # Primary network interface e.g. ens160
    gateway_ipv4     = string       # IPv4 gateway e.g 10.1.1.250
    roles            = list(string) # e.g. ["etcd", "controlplane", "worker"]
    labels           = map(string)  # e.g. {gateway = "vpn"}
  }))
  default = [
    {
      name             = "k8s01"
      cpu_cores        = 4
      memory_mb        = 4096
      longhorn_disk_gb = 32
      interface        = "ens160"
      gateway_ipv4     = "10.1.1.250"
      roles            = ["etcd", "controlplane", "worker"]
      labels = {
        gateway = "vpn"
      }
    },
    {
      name             = "k8s02"
      cpu_cores        = 4
      memory_mb        = 4096
      longhorn_disk_gb = 32
      interface        = "ens160"
      gateway_ipv4     = "10.1.1.250"
      roles            = ["etcd", "controlplane", "worker"]
      labels = {
        gateway = "vpn"
      }
    },
    {
      name             = "k8s03"
      cpu_cores        = 4
      memory_mb        = 4096
      longhorn_disk_gb = 32
      interface        = "ens160"
      gateway_ipv4     = "10.1.1.250"
      roles            = ["etcd", "controlplane", "worker"]
      labels = {
        gateway = "vpn"
      }
    }
  ]
}
variable notifier_smtp_recipient {
  type = string
}
variable notifier_smtp_host {
  type = string
}
variable notifier_smtp_port {
  type    = number
  default = 587
}
variable notifier_smtp_tls {
  type    = bool
  default = true
}
variable notifier_smtp_sender {
  type    = string
  default = "k8s@xmple.io"
}
variable notifier_smtp_username {
  type = string
}
variable notifier_smtp_password {
  type = string
}