###############################################################################
# vSphere
variable vsphere_server {}
variable vsphere_port {
  default = 443
}
variable vsphere_username {}
variable vsphere_password {}
variable vsphere_datacenter {
  default = "Datacenter"
}
variable vsphere_pool {}
variable vsphere_vm_folder {
  default = "Rancher"
}
variable vsphere_vm_network {
  default = "DPortGroup"
}
variable vsphere_vm_datastore {}
variable vsphere_iso_datastore {}

###############################################################################
# GitHub
variable github_username {}

###############################################################################
# Docker
variable docker_registry {}

###############################################################################
# Rancher Server
variable rancher_version_tag {
  default = "v2.4.3"
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

###############################################################################
# FreeIPA
variable freeipa_servers {
  type = list
}
variable freeipa_dn {
  type = string
}
variable freeipa_password {
  type = string
}
variable freeipa_user_search_base {
  type = string
}
variable freeipa_group_search_base {
  type = string
}
variable freeipa_restricted_group {
  type = string
}