## rinebergc/homelab
Homelab Configuration Repo

Provisioning a new server with Portainer:
- wget https://raw.githubusercontent.com/rinebergc/homelab/main/flatcar-butane.yaml
- cat flatcar-butane.yaml | docker run --rm -i quay.io/coreos/butane:latest > ignition.json
- sudo flatcar-install -d /dev/sda -C stable -i ignition.json
