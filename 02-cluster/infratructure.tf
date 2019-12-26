resource vsphere_virtual_machine node {
  count            = length(var.cluster)
  name             = var.cluster[count.index].name
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.vm_datastore.id
  folder           = data.terraform_remote_state.rancher.outputs.rancher_folder

  num_cpus              = data.null_data_source.node_values[count.index].outputs["cpu_cores"]
  num_cores_per_socket  = data.null_data_source.node_values[count.index].outputs["cpu_cores_per_socket"]
  cpu_limit             = data.null_data_source.node_values[count.index].outputs["cpu_limit"]
  memory                = var.cluster[count.index].memory_mb
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

  disk {
    label            = "os_disk"
    size             = var.cluster[count.index].disk_gb
    path             = "OS.vmdk"
    thin_provisioned = true
    eagerly_scrub    = false
  }

  tags = [data.vsphere_tag.rancher.id]
}
