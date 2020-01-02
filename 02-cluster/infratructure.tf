resource vsphere_virtual_disk docker_data {
  count              = length(var.cluster)
  size               = 16
  vmdk_path          = "${var.k8s_name}/docker${count.index}.vmdk"
  datacenter         = data.vsphere_datacenter.dc.name
  datastore          = data.vsphere_datastore.vm_datastore.name
  create_directories = true
  type               = "thin"
}

resource vsphere_virtual_disk longhorn_data {
  count              = length(var.cluster)
  size               = var.cluster[count.index].longhorn_disk_gb
  vmdk_path          = "${var.k8s_name}/longhorn${count.index}.vmdk"
  datacenter         = data.vsphere_datacenter.dc.name
  datastore          = data.vsphere_datastore.vm_datastore.name
  create_directories = true
  type               = "thin"
}

resource vsphere_virtual_machine node {
  count            = length(var.cluster)
  name             = var.cluster[count.index].name
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.vm_datastore.id
  folder           = data.terraform_remote_state.rancher.outputs.rancher_folder

  num_cpus             = data.null_data_source.node_values[count.index].outputs["cpu_cores"]
  num_cores_per_socket = data.null_data_source.node_values[count.index].outputs["cpu_cores_per_socket"]
  cpu_limit            = data.null_data_source.node_values[count.index].outputs["cpu_limit"]
  memory               = var.cluster[count.index].memory_mb

  guest_id         = data.vsphere_virtual_machine.template.guest_id
  firmware         = data.vsphere_virtual_machine.template.firmware
  scsi_type        = data.vsphere_virtual_machine.template.scsi_type
  enable_disk_uuid = true

  force_power_off       = true
  shutdown_wait_timeout = 1

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    //linked_clone  = true
  }

  extra_config = {
    "disk.enableUUID"             = "TRUE" // is this still needed? see enable_disk_uuid=true above
    "guestinfo.metadata"          = base64encode(data.template_file.cloud_config_metadata_ubuntu[count.index].rendered)
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = base64encode(data.template_file.cloud_config_userdata_ubuntu[count.index].rendered)
    "guestinfo.userdata.encoding" = "base64"
  }

  network_interface {
    network_id   = data.vsphere_network.vm.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "os.vmdk"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
    unit_number      = 0
  }

  disk {
    label        = "docker"
    path         = vsphere_virtual_disk.docker_data[count.index].vmdk_path
    attach       = true
    datastore_id = data.vsphere_datastore.vm_datastore.id
    unit_number  = 1
  }

  disk {
    label        = "longhorn"
    path         = vsphere_virtual_disk.longhorn_data[count.index].vmdk_path
    attach       = true
    datastore_id = data.vsphere_datastore.vm_datastore.id
    unit_number  = 2
  }

  tags = [data.vsphere_tag.rancher.id]
}
