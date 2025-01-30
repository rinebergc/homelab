# Ansible Playbook

This playbook configures Debian-based distros for use in my homelab.

## Installation

### Local
  1. [Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) on the Managed (host) Node.
  2. Clone this repository and `cd` into it.
  3. Run `$ ansible-galaxy install -r requirements.yml` to install the required Ansible collections/roles.
  4. Run `$ ansible-playbook main.yml -c local --skip-tags "remote"` to execute the playbook.

### Remote (SSH)
  1. [Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) on the Control Node.
  2. Clone this repository and `cd` into it.
  3. Run `$ ansible-galaxy install -r requirements.yml` to install the required Ansible collections/roles.
  4. Run `$ ansible-playbook main.yml -i inventory.ini -u <REMOTE_USER> -k (--ask-pass) -K (--ask-become-pass)` to execute the playbook.
