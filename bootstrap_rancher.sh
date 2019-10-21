#!/bin/bash
set -e
ansible-playbook --inventory localhost, bootstrap.yaml "$@"
