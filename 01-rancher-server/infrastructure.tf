resource vsphere_tag_category rancher {
  name        = "Rancher"
  cardinality = "SINGLE"
  description = "Managed by Rancher"

  associable_types = [
    "VirtualMachine",
  ]
}

resource vsphere_tag rancher {
  name        = "backup"
  category_id = vsphere_tag_category.rancher.id
  description = "Managed by Rancher"
}

resource vsphere_folder folder {
  path          = var.vsphere_vm_folder
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource vsphere_virtual_machine rancher {
  name             = "Rancher"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.vm_datastore.id
  folder           = vsphere_folder.folder.path

  num_cpus             = 1
  num_cores_per_socket = 1
  memory               = 4096
  guest_id             = "other4xLinux64Guest"
  alternate_guest_name = "RancherOS"
  firmware             = "bios"
  scsi_type            = "pvscsi"

  extra_config = {
    "guestinfo.cloud-init.config.data"   = base64encode(data.template_file.rancher_cloud_config.rendered)
    "guestinfo.cloud-init.data.encoding" = "base64"
  }

  cdrom {
    datastore_id = data.vsphere_datastore.iso_datastore.id
    path         = var.rancher_iso_path
  }

  network_interface {
    network_id   = data.vsphere_network.vm.id
    adapter_type = "vmxnet3"
  }

  disk {
    label            = "os_disk"
    size             = 8
    path             = "RancherOS.vmdk"
    thin_provisioned = true
    eagerly_scrub    = false
  }

  tags = [vsphere_tag.rancher.id]
}

resource null_resource wait_for_rancher {
  provisioner "local-exec" {
    command = <<EOF
while [ "$${subject}" != "*  subject: CN=$${RANCHER_FQDN}" ]; do
    subject=$(curl -vk -m 2 "https://$${RANCHER_FQDN}/ping" 2>&1 | grep "subject:")
    echo "Cert Subject Response: $${subject}"
    if [ "$${subject}" != "*  subject: CN=$${RANCHER_FQDN}" ]; then
      sleep 10
    fi
done
while [ "$${resp}" != "pong" ]; do
    resp=$(curl -sSk -m 2 "https://$${RANCHER_FQDN}/ping")
    echo "Rancher Response: $${resp}"
    if [ "$${resp}" != "pong" ]; then
      sleep 10
    fi
done
EOF

    environment = {
      RANCHER_FQDN = "${var.rancher_hostname}.${var.rancher_domain}"
    }
  }

  depends_on = [dns_a_record_set.rancher]
}