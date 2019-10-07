resource tls_private_key ssh {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource local_file private_key {
  sensitive_content = tls_private_key.ssh.private_key_pem
  filename          = "${path.module}/outputs/id_rsa"

  provisioner local-exec {
    command = "chmod 0600 ${path.module}/outputs/id_rsa"
  }
}

resource local_file public_key {
  content  = tls_private_key.ssh.public_key_openssh
  filename = "${path.module}/outputs/id_rsa.pub"
}
