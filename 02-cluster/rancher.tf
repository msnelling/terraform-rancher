resource rancher2_cluster cluster {
  name                      = var.k8s_name
  enable_cluster_monitoring = true

  rke_config {
    kubernetes_version = var.k8s_version

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
        disk {
          scsi_controller_type = data.vsphere_virtual_machine.template.scsi_type
        }
        network {
          public_network = var.vsphere_vm_network
        }
      }
    }

    network {
      plugin = "canal"
      canal_network_provider {
        iface = "ens192"
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
  cluster_id =  rancher2_cluster.cluster.id
}

resource local_file kube_config {
  sensitive_content = rancher2_cluster_sync.cluster.kube_config
  filename          = "${path.module}/outputs/kubeconfig"
  file_permission   = "0600"
}

resource rancher2_notifier email {
  name       = "SMTP"
  cluster_id = rancher2_cluster.cluster.id
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

resource rancher2_auth_config_freeipa freeipa {
  servers                            = ["ipa1.xmple.io"]
  service_account_distinguished_name = "uid=rancher,cn=sysaccounts,cn=etc,dc=xmple,dc=io"
  service_account_password           = "HcUDe7QxDi4WpPBtRZRTrikR"
  user_search_base                   = "cn=users,cn=accounts,dc=xmple,dc=io"
  group_search_base                  = "cn=groups,cn=accounts,dc=xmple,dc=io"
  port                               = 636
  tls                                = true
  certificate                        = filebase64("${path.module}/files/freeipa_root_ca.pem")
}

locals {
  k8s_api_endpoint = yamldecode(rancher2_cluster_sync.cluster.kube_config).clusters[0].cluster.server
  k8s_api_token    = yamldecode(rancher2_cluster_sync.cluster.kube_config).users[0].user.token
}