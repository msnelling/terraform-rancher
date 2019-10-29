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
variable vsphere_vm_datastore {}
variable vsphere_iso_datastore {}

###############################################################################
# Docker
variable docker_registry {}

###############################################################################
# Rancher Server
variable rancher_version_tag {
  default = "v2.3.2"
}
variable rancher_hostname {}
variable rancher_domain {}
variable rancher_admin_password {}
variable rancher_iso_path {
  default = "Kits/ISO/rancheros-vmware.iso"
}

###############################################################################
# NFS
variable nfs_server_ipv4 {}
variable nfs_mount {}

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
# Cloudflare
variable cloudflare_api_email {}
variable cloudflare_api_key {}

###############################################################################
# Traefik
variable traefik_dashboard {
  type    = bool
  default = false
}

###############################################################################
# ACME
variable acme_email {
  type    = string
  default = null
}
variable acme_staging_ca {
  type    = bool
  default = true
}