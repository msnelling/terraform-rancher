resource rancher2_namespace loki {
  name       = "loki"
  project_id = rancher2_project.monitoring.id
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
    ingress_class = var.ingress_class
    hostname = "${var.loki_hostname}.${var.loki_domain}"
  }
}

resource rancher2_app loki {
  name             = "loki-stack"
  template_name    = "loki-stack"
  catalog_name     = "${data.terraform_remote_state.cluster.outputs.cluster_id}:${rancher2_catalog.loki.name}"
  project_id       = rancher2_project.monitoring.id
  target_namespace = rancher2_namespace.loki.name
  values_yaml      = base64encode(data.template_file.loki_values.rendered)
}

resource dns_cname_record loki {
  zone  = "${var.loki_domain}."
  name  = var.loki_hostname
  cname = var.dns_ingress_a_record
  ttl   = 60
}
