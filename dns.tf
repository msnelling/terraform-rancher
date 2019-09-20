provider dns {
  update {
    server        = var.dns_update_server
    key_name      = var.dns_update_key
    key_algorithm = var.dns_update_algorithm
    key_secret    = var.dns_update_secret
  }
}

resource dns_a_record_set rancher {
  zone      = "${var.rancher_domain}."
  name      = var.rancher_hostname
  addresses = [vsphere_virtual_machine.rancher.default_ip_address]
  ttl       = 60
}
