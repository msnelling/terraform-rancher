resource rancher2_cluster cluster {
  name                      = var.k8s_name
  enable_cluster_monitoring = true

  rke_config {
    kubernetes_version = var.k8s_version
    addons_include = [
      "https://raw.githubusercontent.com/metallb/metallb/v${var.metallb_version}/manifests/namespace.yaml",
      "https://raw.githubusercontent.com/metallb/metallb/v${var.metallb_version}/manifests/metallb.yaml",
    ]

    cloud_provider {
      name = "vsphere"
      vsphere_cloud_provider {
        global {
          insecure_flag = true
        }
        virtual_center {
          datacenters = var.vsphere_datacenter
          name        = var.vsphere_server
          port        = "443"
          user        = var.vsphere_username
          password    = var.vsphere_password
        }
        workspace {
          datacenter        = var.vsphere_datacenter
          server            = var.vsphere_server
          folder            = data.terraform_remote_state.rancher.outputs.rancher_folder
          default_datastore = var.vsphere_vm_datastore
        }
      }
    }

    network {
      plugin = "canal"
    }

    dns {
      provider             = "coredns"
      upstream_nameservers = var.dns_servers
    }

    ingress {
      provider = "none"
    }

    services {
      etcd {
        backup_config {
          /*
          s3_backup_config {
            endpoint    = var.rancher_etcd_backup_s3_endpoint
            region      = var.rancher_etcd_backup_s3_region
            bucket_name = var.rancher_etcd_backup_s3_bucket
            folder      = var.rancher_etcd_backup_s3_folder
            access_key  = var.rancher_etcd_backup_s3_access_key
            secret_key  = var.rancher_etcd_backup_s3_secret_key
            custom_ca   = filebase64("${path.module}/files/s3_root_ca.pem")
          }
          */
        }
      }

      # BEGIN Rapid detection of down node
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
      # END Rapid detection of down node
    }
  }
}

resource rancher2_cluster_sync cluster {
  cluster_id = rancher2_cluster.cluster.id
}

resource local_file kube_config {
  sensitive_content = rancher2_cluster_sync.cluster.kube_config
  filename          = "${path.module}/outputs/kubeconfig"
  file_permission   = "0600"
}

resource rancher2_notifier email {
  name       = "SMTP"
  cluster_id = local.cluster_id
  smtp_config {
    default_recipient = var.notifier_smtp_recipient
    host              = var.notifier_smtp_host
    port              = var.notifier_smtp_port
    tls               = var.notifier_smtp_tls
    sender            = var.notifier_smtp_sender
    username          = var.notifier_smtp_username
    password          = var.notifier_smtp_password
  }
}

locals {
  k8s_api_endpoint = yamldecode(rancher2_cluster_sync.cluster.kube_config).clusters[0].cluster.server
  k8s_api_token    = yamldecode(rancher2_cluster_sync.cluster.kube_config).users[0].user.token
}