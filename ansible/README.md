# Ansible Playbook

This playbook configures Debian-based distros for use in my homelab.

## Installation

### Local
  1. [Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) on to the target machine.
  2. Clone this repository and `cd` into it.
  4. Run `$ ansible-galaxy install -r requirements.yml` to install the required Ansible collections/roles.
  5. Run `$ ansible-playbook main.yml --connection local` to execute the playbook.

### Remote (SSH)
  1. TODO
