resource dns_a_record_set rancher {
  zone      = "${var.rancher_domain}."
  name      = var.rancher_hostname
  addresses = [vsphere_virtual_machine.rancher.default_ip_address]
  ttl       = 60
}
