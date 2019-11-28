output api_url {
  value = rancher2_bootstrap.admin.url
}

output token_key {
  value     = rancher2_bootstrap.admin.token
  sensitive = true
}

output rancher_tag {
  value = vsphere_tag.rancher.id
}

output rancher_folder {
  value = vsphere_folder.folder.path
}