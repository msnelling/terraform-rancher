resource rancher2_namespace metallb {
  name        = "metallb"
  description = "Namespace for metallb app components"
  project_id  = data.rancher2_project.system.id
}

data template_file metallb_values {
  template = file("${path.module}/templates/metallb_values.yaml.tpl")
  vars = {
    image_tag = var.metallb_image_tag
  }
}

resource rancher2_app metallb {
  name             = "metallb"
  catalog_name     = "helm"
  project_id       = data.rancher2_project.system.id
  target_namespace = rancher2_namespace.metallb.name
  template_name    = "metallb"
  values_yaml      = base64encode(data.template_file.metallb_values.rendered)
}

resource kubernetes_config_map metallb_config {
  metadata {
    name      = "metallb-config"
    namespace = rancher2_namespace.metallb.name
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
