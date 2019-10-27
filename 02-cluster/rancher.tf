resource rancher2_cluster cluster {
  name = var.k8s_name

  rke_config {
    authentication {
      //sans = concat(formatlist("%s.${var.k8s_domain}", ))
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
      provider = var.k8s_ingress_provider
      extra_args = {
        default-ssl-certificate = "ingress-nginx/ingress-default-cert"
      }
    }

    # Rapid detection of down node
    services {
      kubelet {
        extra_args = {
          node-status-update-frequency : "5s"
        }
      }
      kube_controller {
        extra_args = {
          node-monitor-period : "2s"
          node-monitor-grace-period : "16s"
          pod-eviction-timeout : "30s"
        }
      }
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

/*
resource rancher2_node_pool master {
  cluster_id       = rancher2_cluster.cluster.id
  name             = "master"
  hostname_prefix  = "test-master-"
  node_template_id = rancher2_node_template.small.id
  quantity         = 1
  control_plane    = true
  etcd             = true
  worker           = true
}

resource rancher2_node_pool minion {
  cluster_id       = rancher2_cluster.cluster.id
  name             = "minion"
  hostname_prefix  = "test-minion-"
  node_template_id = rancher2_node_template.medium.id
  quantity         = 1
  control_plane    = false
  etcd             = false
  worker           = true
}
*/

resource local_file kube_config {
  sensitive_content = rancher2_cluster.cluster.kube_config
  filename          = "${path.module}/outputs/kubeconfig"
  file_permission   = "0600"
}
