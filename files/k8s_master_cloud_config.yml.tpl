#cloud-config
ssh_authorized_keys:
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6Tvl6E1eMdyvazTIRH3eA2qUqTn5lR7pVdWpQQeVT4sBxzN273XqPvxznmVBMxo0QSWYqLPWVLcygmUo/ZYcEOJBgpdDrX71km3iyEp07TMGJzpSJ6Ioy1HHK3P8G+XCESX6SxJS4XrD/IIM9MBL5yAjrjU8lmqQ5s4/y8LLzsTrPiSU3aFaFWRaRUmFSx07zq78pp+B+vVOvM4CC/uaASQbbIz+zfGlIDsOHXjUmYmZVpnHgQMbXldy+ftEGDwqZcFcJOqgEGEMe9+BILh24NuKq8jj6uHXlGw1hoXHn8FPUZ09yMnE5Z+PGgjWqDZa6BOxdcgo/I68l8Jj9pWRH
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDcQE/cTtzHHZ6c1R0ZwGGmebYQI4mzZcdAydfJR/MlQnjW1974tP7EDQ4lM0jL/PqNoePc2t/5TVuG7e+JR/SnJi4wpflRuCZPVyfnf5Q6z/gXPzzdeL15XYPlZJNRrZF5UCBMVR6u9+nMCOLp5uIrSGisBya40elTvxxWeTbmhheXwlUgRFFqujgDm69LaqgQMfctrbjGqbMtmzWxtczYL2ArQKyuml6BYt9itrAb2MGJFLTyyqooWP2rcrrpoKEYhTj6cXA/b750q+CwXhieQuquy2E4ceDDqk2Z/ysiocnnfAsYiUI6lnDTjnJpGJetcR5zLftnHlYXJVxPwBSt
  - ${ssh_key}

#hostname: ${hostname}

write_files:
  - path: /opt/rancher/bin/start.sh
    permissions: "0700"
    owner: root
    content: |
      #!/bin/bash
      echo y | ros install -f -c /cloud-config.yml -d /dev/sda

  - path: /cloud-config.yml
    permissions: "0600"
    owner: root
    content: |
      #cloud-config
      hostname: ${hostname}
      ssh_authorized_keys:
        - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6Tvl6E1eMdyvazTIRH3eA2qUqTn5lR7pVdWpQQeVT4sBxzN273XqPvxznmVBMxo0QSWYqLPWVLcygmUo/ZYcEOJBgpdDrX71km3iyEp07TMGJzpSJ6Ioy1HHK3P8G+XCESX6SxJS4XrD/IIM9MBL5yAjrjU8lmqQ5s4/y8LLzsTrPiSU3aFaFWRaRUmFSx07zq78pp+B+vVOvM4CC/uaASQbbIz+zfGlIDsOHXjUmYmZVpnHgQMbXldy+ftEGDwqZcFcJOqgEGEMe9+BILh24NuKq8jj6uHXlGw1hoXHn8FPUZ09yMnE5Z+PGgjWqDZa6BOxdcgo/I68l8Jj9pWRH
        - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDcQE/cTtzHHZ6c1R0ZwGGmebYQI4mzZcdAydfJR/MlQnjW1974tP7EDQ4lM0jL/PqNoePc2t/5TVuG7e+JR/SnJi4wpflRuCZPVyfnf5Q6z/gXPzzdeL15XYPlZJNRrZF5UCBMVR6u9+nMCOLp5uIrSGisBya40elTvxxWeTbmhheXwlUgRFFqujgDm69LaqgQMfctrbjGqbMtmzWxtczYL2ArQKyuml6BYt9itrAb2MGJFLTyyqooWP2rcrrpoKEYhTj6cXA/b750q+CwXhieQuquy2E4ceDDqk2Z/ysiocnnfAsYiUI6lnDTjnJpGJetcR5zLftnHlYXJVxPwBSt
        - ${ssh_key}
      rancher:
        docker:
          engine: docker-19.03.1
        bootstrap_docker:
          registry_mirror: "https://docker-registry.${domain}"
        docker:
          registry_mirror: "https://docker-registry.${domain}"
        system_docker:
          registry_mirror: "https://docker-registry.${domain}"
        services_include:
          kernel-extras: true
          volume-nfs: true
        network:
          dns:
            nameservers:
%{ for address in split(",", dns_servers) ~}
              - ${address}
%{ endfor ~}
            search:
              - ${domain}
            interfaces:
              eth0:
                dhcp: true
                mtu: 1500
              eth1:
                dhcp: true
                mtu: 9000
