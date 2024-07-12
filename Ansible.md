## Install [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

#### Using PIPx
Install Ful Anaible Package
```
pipx install --include-deps ansible
```

Install Core (Minimal) Ansible Package
```
pipx install ansible-core
````

#### Using PPA
```
sudo apt-add-repository ppa:ansible/ansible
```
```
sudo apt update
```
```
sudo apt install ansible
```

## Creating Inventory File
This file is referenced whtn playbooks are being ran so ansible knows what hosts to communicate with
- Create a file `sudo nano /etc/ansible/hosts`

This is the general format of the file. You can make different names for the sections as seen in the `'[]'`.
```
[servers]
server1 ansible_host=203.0.113.111
server2 ansible_host=203.0.113.112
server3 ansible_host=203.0.113.113

[all:vars]
ansible_python_interpreter=/usr/bin/python3
```
