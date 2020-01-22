# https://github.com/terraform-providers/terraform-provider-kubernetes/issues/215
provider shell {}

variable manifest_yaml {
  type = string
  default = ""
}

variable manifest_url {
  type = string
  default = ""
}

locals {
  manifest_from_yaml_enabled = length(var.manifest_yaml) > 0
  manifest_from_url_enabled = length(var.manifest_url) > 0
}

resource shell_script manifest_from_yaml {
  count = local.manifest_from_yaml_enabled ? 1 : 0
  environment = {
    KUBECTL_MANIFEST_YAML = var.manifest_yaml
  }
  lifecycle_commands {
    # Update the "taint_trigger" in the outputs of the local state
    # when `kubectl diff` shows that the remote resources differ.
    read = <<SCRIPT
      if echo "$KUBECTL_MANIFEST_YAML" | kubectl diff -f -
      then cat >&3 # keep the same state as received from stdin
      else echo '{"taint_trigger": "'$RANDOM'"}' >&3 # state change
      fi
    SCRIPT

    # Use idempotent `kubectl apply` for both create and update.
    create = <<SCRIPT
      echo "$KUBECTL_MANIFEST_YAML" | kubectl apply -f -
    SCRIPT
    update = <<SCRIPT
      echo "$KUBECTL_MANIFEST_YAML" | kubectl apply -f -
    SCRIPT

    # Use `kubectl delete` for delete.
    delete = <<SCRIPT
      echo "$KUBECTL_MANIFEST_YAML" | kubectl delete -f -
    SCRIPT
  }
}

resource shell_script manifest_from_url {
  count = local.manifest_from_url_enabled ? 1 : 0
  lifecycle_commands {
    # Update the "taint_trigger" in the outputs of the local state
    # when `kubectl diff` shows that the remote resources differ.
    read = <<SCRIPT
      if kubectl diff -f ${var.manifest_url}
      then cat >&3 # keep the same state as received from stdin
      else echo '{"taint_trigger": "'$RANDOM'"}' >&3 # state change
      fi
    SCRIPT

    # Use idempotent `kubectl apply` for both create and update.
    create = <<SCRIPT
      kubectl apply -f ${var.manifest_url}
    SCRIPT
    update = <<SCRIPT
      kubectl apply -f ${var.manifest_url}
    SCRIPT

    # Use `kubectl delete` for delete.
    delete = <<SCRIPT
      kubectl delete -f ${var.manifest_url}
    SCRIPT
  }
}