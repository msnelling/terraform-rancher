#cloud-config
ssh_authorized_keys:
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6Tvl6E1eMdyvazTIRH3eA2qUqTn5lR7pVdWpQQeVT4sBxzN273XqPvxznmVBMxo0QSWYqLPWVLcygmUo/ZYcEOJBgpdDrX71km3iyEp07TMGJzpSJ6Ioy1HHK3P8G+XCESX6SxJS4XrD/IIM9MBL5yAjrjU8lmqQ5s4/y8LLzsTrPiSU3aFaFWRaRUmFSx07zq78pp+B+vVOvM4CC/uaASQbbIz+zfGlIDsOHXjUmYmZVpnHgQMbXldy+ftEGDwqZcFcJOqgEGEMe9+BILh24NuKq8jj6uHXlGw1hoXHn8FPUZ09yMnE5Z+PGgjWqDZa6BOxdcgo/I68l8Jj9pWRH
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDcQE/cTtzHHZ6c1R0ZwGGmebYQI4mzZcdAydfJR/MlQnjW1974tP7EDQ4lM0jL/PqNoePc2t/5TVuG7e+JR/SnJi4wpflRuCZPVyfnf5Q6z/gXPzzdeL15XYPlZJNRrZF5UCBMVR6u9+nMCOLp5uIrSGisBya40elTvxxWeTbmhheXwlUgRFFqujgDm69LaqgQMfctrbjGqbMtmzWxtczYL2ArQKyuml6BYt9itrAb2MGJFLTyyqooWP2rcrrpoKEYhTj6cXA/b750q+CwXhieQuquy2E4ceDDqk2Z/ysiocnnfAsYiUI6lnDTjnJpGJetcR5zLftnHlYXJVxPwBSt
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
      ssh_authorized_keys:
        - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6Tvl6E1eMdyvazTIRH3eA2qUqTn5lR7pVdWpQQeVT4sBxzN273XqPvxznmVBMxo0QSWYqLPWVLcygmUo/ZYcEOJBgpdDrX71km3iyEp07TMGJzpSJ6Ioy1HHK3P8G+XCESX6SxJS4XrD/IIM9MBL5yAjrjU8lmqQ5s4/y8LLzsTrPiSU3aFaFWRaRUmFSx07zq78pp+B+vVOvM4CC/uaASQbbIz+zfGlIDsOHXjUmYmZVpnHgQMbXldy+ftEGDwqZcFcJOqgEGEMe9+BILh24NuKq8jj6uHXlGw1hoXHn8FPUZ09yMnE5Z+PGgjWqDZa6BOxdcgo/I68l8Jj9pWRH
        - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDcQE/cTtzHHZ6c1R0ZwGGmebYQI4mzZcdAydfJR/MlQnjW1974tP7EDQ4lM0jL/PqNoePc2t/5TVuG7e+JR/SnJi4wpflRuCZPVyfnf5Q6z/gXPzzdeL15XYPlZJNRrZF5UCBMVR6u9+nMCOLp5uIrSGisBya40elTvxxWeTbmhheXwlUgRFFqujgDm69LaqgQMfctrbjGqbMtmzWxtczYL2ArQKyuml6BYt9itrAb2MGJFLTyyqooWP2rcrrpoKEYhTj6cXA/b750q+CwXhieQuquy2E4ceDDqk2Z/ysiocnnfAsYiUI6lnDTjnJpGJetcR5zLftnHlYXJVxPwBSt
      hostname: ${rancher_hostname}.${rancher_domain}
      mounts:
        - ["${nfs_server_ipv4}:${nfs_mount}/server", "/mnt/rancher", "nfs4", ""]
        - ["${nfs_server_ipv4}:${nfs_mount}/acme", "/mnt/acme", "nfs4", ""]
      rancher:
        bootstrap_docker:
          registry_mirror: "https://${docker_registry}"
        docker:
          registry_mirror: "https://${docker_registry}"
        system_docker:
          registry_mirror: "https://${docker_registry}"
        services_include:
          volume-nfs: true
        network:
          dns:
            nameservers:
%{ for address in split(",", dns_servers) ~}
              - ${address}
%{ endfor ~}
            search:
              - ${rancher_domain}
          interfaces:
            eth0:
              dhcp: true
              mtu: 1500
        services:
          rancher-server:
            hostname: rancher
            image: rancher/rancher:v2.3.0
            command:
              - --no-cacerts
            volumes:
              - /mnt/rancher:/var/lib/rancher:rw
            restart: unless-stopped
            labels:
              traefik.enable: "true"
              traefik.http.routers.rancher-insecure.rule: Host(`${rancher_hostname}.${rancher_domain}`)
              traefik.http.routers.rancher-insecure.entrypoints: web
              traefik.http.routers.rancher-insecure.middlewares: httpsredirect
              traefik.http.routers.rancher.rule: Host(`${rancher_hostname}.${rancher_domain}`)
              traefik.http.routers.rancher.entrypoints: websecure
              traefik.http.routers.rancher.middlewares: sslheader
              traefik.http.routers.rancher.tls.certresolver: default
              traefik.http.middlewares.httpsredirect.redirectscheme.scheme: https
              traefik.http.middlewares.sslheader.headers.customrequestheaders.X-Forwarded-Proto: https
              traefik.http.services.rancher.loadbalancer.server.scheme: http
              traefik.http.services.rancher.loadbalancer.server.port: "80"
              traefik.http.services.rancher.loadbalancer.passhostheader: "true"
          traefik:
            image: traefik:v2.0
            command:
              - --log.level=INFO
              - --entrypoints.web.address=:80
              - --entrypoints.websecure.address=:443
%{ if traefik_dashboard ~}
              - --api=true
              - --api.dashboard
              - --entrypoints.traefik.address=:8080
%{ endif ~}
              - --providers.docker=true
              - --providers.docker.exposedbydefault=false
              - --certificatesResolvers.default=true
              - --certificatesResolvers.default.acme.storage=/acme/acme.json
              - --certificatesResolvers.default.acme.caserver=${acme_ca_server}
              - --certificatesResolvers.default.acme.dnschallenge=true
              - --certificatesResolvers.default.acme.dnschallenge.provider=cloudflare
              - --certificatesResolvers.default.acme.dnschallenge.delayBeforeCheck=0
              - --certificatesResolvers.default.acme.dnschallenge.resolvers=1.1.1.1:53,1.0.0.1:53
            environment:
              CLOUDFLARE_EMAIL: ${cloudflare_api_email}
              CLOUDFLARE_API_KEY: ${cloudflare_api_key}
            ports:
              - 80:80/tcp
              - 443:443/tcp
%{ if traefik_dashboard ~}
              - 8080:8080/tcp
%{ endif ~}
            volumes:
              - /var/run/docker.sock:/var/run/docker.sock:ro
              - /mnt/acme:/acme:rw
            restart: unless-stopped
%{ if traefik_dashboard ~}
            labels:
              traefik.enable: "true"
              traefik.http.routers.api.rule: Host(`${rancher_hostname}.${rancher_domain}`)
              traefik.http.routers.api.entrypoints: traefik
              traefik.http.routers.api.service: api@internal
%{ endif ~}
