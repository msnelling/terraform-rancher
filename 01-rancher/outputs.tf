output api_url {
  value = rancher2_bootstrap.admin.url
}

output token_key {
  value     = rancher2_bootstrap.admin.token
  sensitive = true
}

output vm_tag_catagory_id {
  value = vsphere_tag_category.rancher.id
}

output vm_tag_rancher {
  value = vsphere_tag.rancher.name
}

output rancher_folder {
  value = vsphere_folder.folder.path
}
