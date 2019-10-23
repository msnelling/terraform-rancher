resource tls_private_key ssh {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource local_file private_key {
  sensitive_content = tls_private_key.ssh.private_key_pem
  filename          = "${path.module}/outputs/id_rsa"
  file_permission   = "0600"
}

resource local_file public_key {
  content         = tls_private_key.ssh.public_key_openssh
  filename        = "${path.module}/outputs/id_rsa.pub"
  file_permission = "0600"
}
