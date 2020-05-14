resource kubernetes_config_map metallb_config {
  metadata {
    name      = "config"
    namespace = "metallb-system"
  }
  data = {
    config = <<EOF
address-pools:
  - name: default
    protocol: layer2
    addresses:
      - ${var.metallb_address_pool}
EOF
  }
}

resource random_string metallb_memberlist {
  length = 128
}

resource kubernetes_secret metallb_memberlist {
  metadata {
    name      = "memberlist"
    namespace = "metallb-system"
  }
  data = {
    secretkey = base64encode(random_string.metallb_memberlist.result)
  }
}