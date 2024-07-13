## Install [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

#### Using PIPx
Install Full Anaible Package
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

This is the general format of the file. You can make different names for the sections as seen in the `'[]'` to ahve differnet hosts grouped together.
```
[servers]
server1 ansible_host=203.0.113.111
server2 ansible_host=203.0.113.112
server3 ansible_host=203.0.113.113

[all:vars]
ansible_python_interpreter=/usr/bin/python3
```

## Generate SSH Keys for remote authentication

Enter the command to generate a key in the ed25519 key type with a comment for the key. (No Password - just hit enter)
```
ssh-copy-id -t ed25519 -C "Ansible" 

```
When prompted we would like to enter the full path for the file to name this file so there is no confusion with other ssh keys
`/home/USER/.ssh/ansible`

When the key is generated we need to copy the public key to the remote hosts so ansible can connect to them. Need to do this for all servers
```
ssh-copy-id -i ~/.ssh/ansible.pub IP_ADDRESS_OF_REMOTE_SERVER
```
Test that the connection is working with:
```
ssh -i ~/.ssh/ansible REMOTE_IP
```


## Usage of Ansible 

Create a playbook directory to store your playbooks that ansible will use to perform
```
Sudo mkdir /etc/ansible/playbooks
```

This is an example of a playbook that wil update and uprgade ubuntu/debian based servers. This will also reboot the servers if needed.
We can see the `hosts` section, and this is referenced in the inventory file we created previously.
```
---
- hosts: ubuntu
  become: true
  become_user: root
  tasks:
    - name: Update apt repo and cache on all Debian/Ubuntu boxes
      apt: update_cache=yes force_apt_get=yes cache_valid_time=3600

    - name: Upgrade all packages on servers
      apt: upgrade=dist force_apt_get=yes

    - name: Check if a reboot is needed on all servers
      register: reboot_required_file
      stat: path=/var/run/reboot-required

    - name: Reboot the box if kernel updated
      reboot:
        msg: "Reboot initiated by Ansible for kernel updates"
        connect_timeout: 5
        reboot_timeout: 300
        pre_reboot_delay: 0
        post_reboot_delay: 30
        test_command: uptime
      when: reboot_required_file.stat.exists
```

To use this playbook to update and uprgade our servers we need to:
- Make sure the hosts are referenced properly in the inventory and playbook files
- We need to make sure all public keys were sent from the Ansible server to the remote hosts listed in the inventory file

  Run this command to execute the playbook. We have named this playbook `ubuntu-update.yml`:
  ```
  ansible-playbook /etc/ansible/playbooks/ubuntu-update.yml -K
  ```
