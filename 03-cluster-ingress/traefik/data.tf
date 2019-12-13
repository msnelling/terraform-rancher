/*
data external catalog_refresh {
  program = [
    "curl",
    "--fail",
    "-H", "Authorization: Bearer ${data.terraform_remote_state.rancher.outputs.token_key}",
    "-X", "POST",
    "${data.terraform_remote_state.rancher.outputs.api_url}/v3/catalogs/${rancher2_catalog.traefik.name}?action=refresh"
  ]

  depends_on = [rancher2_catalog.traefik]
}
*/

data template_file traefik_config {
  template = file("${path.module}/templates/traefik_config.yaml.tpl")
}
