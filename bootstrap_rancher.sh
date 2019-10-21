#!/bin/bash
set -e
ansible-playbook --inventory localhost, bootstrap_rancher.yaml --extra-vars '{"state":"present"}' "$@"
