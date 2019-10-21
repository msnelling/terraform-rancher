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
  organization          = var.organization
  file_triggers_enabled = false
  operations            = false
  queue_all_runs        = false
}