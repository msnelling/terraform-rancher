provider tfe {
  hostname = var.hostname
}

resource tfe_organization myorg {
  name                     = var.organization
  email                    = var.email_address
  collaborator_auth_policy = "two_factor_mandatory"
}

resource tfe_workspace rancher {
  name                  = "rancher"
  organization          = tfe_organization.myorg.name
  file_triggers_enabled = false
  operations            = false
  queue_all_runs        = false
}

resource tfe_workspace k8s {
  name                  = "k8s"
  organization          = tfe_organization.myorg.name
  file_triggers_enabled = false
  operations            = false
  queue_all_runs        = false
}

resource tfe_workspace k8s_base {
  name                  = "k8s-base"
  organization          = tfe_organization.myorg.name
  file_triggers_enabled = false
  operations            = false
  queue_all_runs        = false
}

resource tfe_workspace k8s_ingress {
  name                  = "k8s-ingress"
  organization          = tfe_organization.myorg.name
  file_triggers_enabled = false
  operations            = false
  queue_all_runs        = false
}

resource tfe_workspace k8s_apps {
  name                  = "k8s-apps"
  organization          = tfe_organization.myorg.name
  file_triggers_enabled = false
  operations            = false
  queue_all_runs        = false
}
