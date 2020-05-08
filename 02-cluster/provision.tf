resource null_resource wait_for_docker {
  count = length(var.cluster)

  triggers = {
    node_instance_id = vsphere_virtual_machine.node[count.index].id
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
      IP   = vsphere_virtual_machine.node[count.index].default_ip_address
      KEY  = "${path.root}/outputs/id_rsa"
      RET  = "1"
    }
  }

  depends_on = [dns_a_record_set.node]
}

resource null_resource add_to_cluster {
  count = length(var.cluster)

  triggers = {
    node_instance_id = vsphere_virtual_machine.node[count.index].id
    cluster_token    = rancher2_cluster.cluster.cluster_registration_token[0].token
  }

  provisioner remote-exec {
    connection {
      type        = "ssh"
      host = vsphere_virtual_machine.node[count.index].default_ip_address
      user        = "rancher"
      private_key = tls_private_key.ssh.private_key_pem
    }

    inline = [
      "${data.null_data_source.node_values[count.index].outputs["node_command"]} ${data.null_data_source.node_values[count.index].outputs["role_params"]} ${data.null_data_source.node_values[count.index].outputs["label_params"]}"
    ]
  }

  depends_on = [null_resource.wait_for_docker]
}
