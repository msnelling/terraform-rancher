data template_file cert_manager_staging_issuer {
  template = file("${path.module}/templates/cloudflare_issuer.yaml.tpl")
  vars = {
    issuer_name          = "letsencrypt-staging"
    acme_ca_server       = "https://acme-staging-v02.api.letsencrypt.org/directory"
    acme_email           = var.acme_email
    cloudflare_api_email = var.cloudflare_api_email
  }
}

data template_file cert_manager_production_issuer {
  template = file("${path.module}/templates/cloudflare_issuer.yaml.tpl")
  vars = {
    issuer_name          = "letsencrypt-production"
    acme_ca_server       = "https://acme-v02.api.letsencrypt.org/directory"
    acme_email           = var.acme_email
    cloudflare_api_email = var.cloudflare_api_email
  }
}

resource rancher2_namespace cert_manager {
  name        = "cert-manager"
  description = "Namespace for cert-manager app components"
  project_id  = data.rancher2_project.system.id
}

resource rancher2_secret cloudflare_api {
  name         = "cloudflare-api-key"
  project_id   = data.rancher2_project.system.id
  namespace_id = "cert-manager"
  data = {
    api-key = base64encode(var.cloudflare_api_key)
  }
}

resource null_resource cert_manager_crds {
  provisioner "local-exec" {
    command = "kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.11/deploy/manifests/00-crds.yaml"
    environment = {
      KUBECONFIG = local_file.kube_config.filename
    }
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "kubectl delete -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.11/deploy/manifests/00-crds.yaml"
    environment = {
      KUBECONFIG = local_file.kube_config.filename
    }
  }

  depends_on = [rancher2_namespace.cert_manager]
}

/* I can't seem to get the app to work
resource rancher2_app cert_manager {
  name             = "cert-manager"
  catalog_name     = "cert-manager"
  project_id       = data.rancher2_project.system.id
  target_namespace = rancher2_namespace.cert_manager.name
  template_name    = "cert-manager"
  answers = {
    "image.pullPolicy" = "Always"
    "extraArgs"        = "–dns01-recursive-nameservers=1.1.1.1:53,1.0.0.1:53"
  }
  depends_on = [null_resource.cert_manager_crds]
}
*/

resource null_resource cert_manager_install {
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v0.11.0/cert-manager.yaml"
    environment = {
      KUBECONFIG = local_file.kube_config.filename
    }
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "kubectl delete -f https://github.com/jetstack/cert-manager/releases/download/v0.11.0/cert-manager.yaml"
    environment = {
      KUBECONFIG = local_file.kube_config.filename
    }
  }

  depends_on = [
    rancher2_namespace.cert_manager,
    null_resource.cert_manager_crds
  ]
}

resource local_file cert_manager_staging_issuer {
  sensitive_content = data.template_file.cert_manager_staging_issuer.rendered
  filename          = "${path.module}/outputs/cert_manager_staging_issuer.yaml"
  file_permission   = "0600"
}

resource local_file cert_manager_production_issuer {
  sensitive_content = data.template_file.cert_manager_production_issuer.rendered
  filename          = "${path.module}/outputs/cert_manager_production_issuer.yaml"
  file_permission   = "0600"
}

resource null_resource cert_manager_staging_issuer_install {
  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.cert_manager_staging_issuer.filename}"
    environment = {
      KUBECONFIG = local_file.kube_config.filename
    }
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "kubectl delete -f ${local_file.cert_manager_staging_issuer.filename}"
    environment = {
      KUBECONFIG = local_file.kube_config.filename
    }
  }

  depends_on = [
    null_resource.cert_manager_install,
    data.template_file.cert_manager_staging_issuer
  ]
}

resource null_resource cert_manager_production_issuer_install {
  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.cert_manager_production_issuer.filename}"
    environment = {
      KUBECONFIG = local_file.kube_config.filename
    }
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "kubectl delete -f ${local_file.cert_manager_production_issuer.filename}"
    environment = {
      KUBECONFIG = local_file.kube_config.filename
    }
  }

  depends_on = [
    null_resource.cert_manager_install,
    data.template_file.cert_manager_production_issuer
  ]
}
