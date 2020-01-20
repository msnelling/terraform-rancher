resource kubernetes_storage_class vsphere_nvme_ephemeral {
  metadata {
    name = "vsphere-nvme-ephemeral"
  }
  storage_provisioner = "kubernetes.io/vsphere-volume"
  reclaim_policy      = "Delete"
  parameters = {
    diskformat = "thin"
    datastore  = var.vsphere_vm_datastore
    fsType     = "ext4"
  }

  depends_on = [rancher2_cluster_sync.cluster]
}

resource kubernetes_storage_class vsphere_nvme_persistent {
  metadata {
    name = "vsphere-nvme-persistent"
  }
  storage_provisioner = "kubernetes.io/vsphere-volume"
  reclaim_policy      = "Retain"
  parameters = {
    diskformat = "thin"
    datastore  = var.vsphere_vm_datastore
    fsType     = "ext4"
  }

  depends_on = [rancher2_cluster_sync.cluster]
}