resource vsphere_virtual_machine k8s_node {
  count                 = length(var.k8s_cluster)
  name                  = var.k8s_cluster[count.index].name
  resource_pool_id      = data.vsphere_resource_pool.pool.id
  datastore_id          = data.vsphere_datastore.vm_datastore.id
  num_cpus              = data.null_data_source.node_values[count.index].outputs["cpu_cores"]
  num_cores_per_socket  = data.null_data_source.node_values[count.index].outputs["cpu_cores_per_socket"]
  cpu_limit             = data.null_data_source.node_values[count.index].outputs["cpu_limit"]
  memory                = var.k8s_cluster[count.index].memory_mb
  guest_id              = "other4xLinux64Guest"
  alternate_guest_name  = "RancherOS"
  firmware              = "bios"
  scsi_type             = "pvscsi"
  force_power_off       = true
  shutdown_wait_timeout = 1

  extra_config = {
    "guestinfo.cloud-init.config.data"   = base64encode(data.template_file.cloud_config_rancheros[count.index].rendered)
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

  network_interface {
    network_id   = data.vsphere_network.aux.id
    adapter_type = "vmxnet3"
  }

  disk {
    label            = "os_disk"
    size             = var.k8s_cluster[count.index].disk_gb
    path             = "OS.vmdk"
    thin_provisioned = true
    eagerly_scrub    = false
  }
}

resource null_resource wait_for_docker {
  count = length(var.k8s_cluster)

  triggers = {
    node_instance_id = vsphere_virtual_machine.k8s_node[count.index].id
  }

  provisioner local-exec {
    command = <<EOF
while [ "$${RET}" -gt 0 ]; do
  ssh -q -o StrictHostKeyChecking=no -i $${KEY} $${USER}@$${IP} 'docker ps 2>&1 >/dev/null'
  RET=$?
  if [ "$${RET}" -gt 0 ]; then
    sleep 10
  fi
done
EOF

    environment = {
      USER = "rancher"
      IP   = data.null_data_source.node_values[count.index].outputs["address_ipv4"]
      KEY  = "${path.root}/outputs/id_rsa"
      RET  = "1"
    }
  }

  depends_on = [dns_a_record_set.node]
}

resource null_resource add_to_cluster {
  count = length(var.k8s_cluster)

  triggers = {
    node_instance_id = vsphere_virtual_machine.k8s_node[count.index].id
    cluster_token    = rancher2_cluster.cluster.cluster_registration_token[0].token
  }

  provisioner remote-exec {
    connection {
      type        = "ssh"
      host        = data.null_data_source.node_values[count.index].outputs["address_ipv4"]
      user        = "rancher"
      private_key = tls_private_key.ssh.private_key_pem
    }

    inline = [
      "${data.null_data_source.node_values[count.index].outputs["node_command"]} ${data.null_data_source.node_values[count.index].outputs["role_params"]} ${data.null_data_source.node_values[count.index].outputs["label_params"]}"
    ]
  }

  depends_on = [null_resource.wait_for_docker]
}
