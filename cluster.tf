resource tls_private_key k8s_cluster {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource rancher2_cluster test {
  name = "test"

  rke_config {
    authentication {
      sans = [
        "${var.k8s_cluster[0].name}.${var.k8s_domain}",
        split("/", var.k8s_cluster[0].address_cidr_ipv4)[0],
      ]
    }

    network {
      plugin = "canal"
      canal_network_provider {
        iface = "eth0"
      }
    }

    dns {
      provider             = "coredns"
      upstream_nameservers = var.dns_servers
    }

    ingress {
      provider = "none"
    }

    /*cloud_provider {
      name = "vsphere"
      vsphere_cloud_provider {
        virtual_center {
          datacenters = var.vsphere_datacenter
          name        = var.vsphere_server
          user        = var.vsphere_username
          password    = var.vsphere_password
        }
        workspace {
          datacenter        = var.vsphere_datacenter
          folder            = "/"
          default_datastore = ""
          server            = var.vsphere_server
        }
        network {
          public_network = var.vsphere_vm_network
        }
        global {
          insecure_flag = true
        }
      }
    }*/
  }
}

data template_file k8s_cloud_config {
  count    = length(var.k8s_cluster)
  template = file("${path.module}/files/k8s_master_cloud_config.yml.tpl")

  vars = {
    ssh_key           = tls_private_key.k8s_cluster.public_key_openssh
    hostname          = "${var.k8s_cluster[count.index].name}.${var.k8s_domain}"
    docker_registry   = var.docker_registry
    dns_servers       = join(",", var.dns_servers)
    dns_domain        = var.k8s_domain
    address_cidr_ipv4 = var.k8s_cluster[count.index].address_cidr_ipv4
    gateway_ipv4      = var.k8s_cluster[count.index].gateway_ipv4
  }
}

resource vsphere_virtual_machine k8s_node {
  count                 = length(var.k8s_cluster)
  name                  = var.k8s_cluster[count.index].name
  resource_pool_id      = data.vsphere_resource_pool.pool.id
  datastore_id          = data.vsphere_datastore.vm_datastore.id
  num_cpus              = var.k8s_cluster[count.index].cpu_cores
  num_cores_per_socket  = var.k8s_cluster[count.index].cpu_cores
  memory                = var.k8s_cluster[count.index].memory_mb
  guest_id              = "other4xLinux64Guest"
  alternate_guest_name  = "RancherOS"
  firmware              = "bios"
  scsi_type             = "pvscsi"
  force_power_off       = true
  shutdown_wait_timeout = 1

  extra_config = {
    "guestinfo.cloud-init.config.data"   = base64encode(data.template_file.k8s_cloud_config[count.index].rendered)
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

data null_data_source values {
  count = length(var.k8s_cluster)

  inputs = {
    node_command = rancher2_cluster.test.cluster_registration_token[0].node_command
    address_ipv4 = split("/", var.k8s_cluster[count.index].address_cidr_ipv4)[0]
    role_params  = join(" ", formatlist("--%s ", var.k8s_cluster[count.index].roles))
    label_params = join(" ", formatlist("--label %s=%s ", keys(var.k8s_cluster[count.index].labels), values(var.k8s_cluster[count.index].labels)))
  }
}

resource null_resource k8s_master_provision {
  count = length(var.k8s_cluster)

  triggers = {
    node_instance_id = vsphere_virtual_machine.k8s_node[count.index].id
    cluster_token    = rancher2_cluster.test.cluster_registration_token[0].token
  }

  provisioner remote-exec {
    connection {
      type        = "ssh"
      host        = data.null_data_source.values[count.index].outputs["address_ipv4"]
      user        = "rancher"
      private_key = tls_private_key.k8s_cluster.private_key_pem
    }

    inline = [
      "${data.null_data_source.values[count.index].outputs["node_command"]} ${data.null_data_source.values[count.index].outputs["role_params"]} ${data.null_data_source.values[count.index].outputs["label_params"]}"
    ]
  }
}

/*
resource rancher2_node_pool master {
  cluster_id       = rancher2_cluster.test.id
  name             = "master"
  hostname_prefix  = "test-master-"
  node_template_id = rancher2_node_template.small.id
  quantity         = 1
  control_plane    = true
  etcd             = true
  worker           = true
}

resource rancher2_node_pool minion {
  cluster_id       = rancher2_cluster.test.id
  name             = "minion"
  hostname_prefix  = "test-minion-"
  node_template_id = rancher2_node_template.medium.id
  quantity         = 1
  control_plane    = false
  etcd             = false
  worker           = true
}
*/
