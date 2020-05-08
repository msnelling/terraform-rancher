
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
