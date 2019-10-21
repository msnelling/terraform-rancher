#!/bin/bash
set -e
ansible-playbook --inventory localhost, teardown.yaml "$@"
