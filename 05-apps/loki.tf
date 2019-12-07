resource rancher2_namespace loki {
  name        = "loki"
  description = "Namespace for Loki app components"
  project_id  = data.rancher2_project.system.id
}

resource rancher2_catalog loki {
  name       = "loki"
  url        = "https://grafana.github.io/loki/charts"
  scope      = "cluster"
  cluster_id = data.terraform_remote_state.cluster.outputs.cluster_id
}

data template_file loki_values {
  template = file("${path.module}/templates/loki_values.yaml.tpl")
  vars = {
    hostname = var.loki_hostname
  }
}

resource rancher2_app loki {
  name             = "loki-stack"
  catalog_name     = "${data.terraform_remote_state.cluster.outputs.cluster_id}:${rancher2_catalog.loki.name}"
  project_id       = data.rancher2_project.system.id
  target_namespace = rancher2_namespace.loki.name
  template_name    = "loki-stack"
  values_yaml      = base64encode(data.template_file.loki_values.rendered)
}
