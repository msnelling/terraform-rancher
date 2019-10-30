resource rancher2_namespace home_assistant {
  name        = "home-assistant"
  description = "Namespace for home-assistant app components"
  project_id  = data.rancher2_project.default.id
}

resource rancher2_app home_assistant {
  name             = "home-assistant"
  catalog_name     = "helm"
  project_id       = data.rancher2_project.default.id
  target_namespace = rancher2_namespace.home_assistant.name
  template_name    = "home-assistant"
  values_yaml      = base64encode(data.template_file.home_assistant_values.rendered)
}

data template_file home_assistant_values {
  template = file("${path.module}/templates/hass_values.yaml.tpl")
}