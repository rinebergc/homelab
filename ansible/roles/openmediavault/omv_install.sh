- name: Install OpenMediaVault
  ansible.builtin.shell:
    cmd: wget -O - https://github.com/OpenMediaVault-Plugin-Developers/installScript/raw/master/install | sudo bash
