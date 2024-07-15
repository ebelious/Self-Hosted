# This is a Guide for Proxmox insallation
Proxmox is a type 1 hypervisor akin to vmware esxi. This guide will show how to do basic configurations, GPU / PCI passthrough, taking backups, and creating users and giving permissions.

## How to install Proxmox
Go to [Proxmoxs](https://www.proxmox.com/en/downloads) website and download the ISO

#### Create Boot Disk
Make a bootable USB drive using a software like [Rufus](https://rufus.ie/en/) or [Belena Etcher](https://etcher.balena.io/)

Make sure that virtualization is configured in UEFI/BIOS settings, if this is not enable this will not work

Start the system and boot from the USB and when the splash page loads select the graphical installer option
- Select what disks you want to install proxmox in the drop down and if you want to configure  the disks in raid
- Configure locale and keyboard layout
- Configure username and password and enter an email address
- Configure the Networking informarion for the server

Verify the configurations and then **Install!**

Navigate to this url with the IP you configured for the server `https://IP_ADDRESS:8006` <br />
** **Note: If you are using the root user to sign in, you need to have the realm be `Linux Pam standard authentication`**

## Configure the community repositories
Go to the proxmox shell option and login. Use this command to add the proxmox community repo

Via CLI:
```
echo "deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription" >> /etc/apt/sources.list`
```
Via WebUI:

Navigate to `Upgrades` > `Repositores` and click `Add`. In this Respository drop down menu select `No-Subscription`

You can either update proxmox through the shell or through the webUI

If youre not the `root` user run this
```
sudo apt update && sudo apt upgrade -y
```
Or you can go to the proxmox host in the left menu and navigate to `Updates` and click `Refresh` to update the repositories and then click `Upgrade` to upgrade the packages. <br />
  *When you see `TASK OK` in the window pop-up, the update has completed and can be closed*

You will then be able to get proxmox updates if you do not pay for proxmox

## Upload ISOs to Proxmox
Navigate to `Proxmox host` >`local` storage and you will see a `ISO Images` option in the menu. Here you can add locally, add by URL, or remove the images. 

#### Download Links: <br />
[Debian](https://www.debian.org/download) <br />
[Ubuntu](https://ubuntu.com/download) <br />
[Alpine](https://alpinelinux.org/downloads/)  <br />
[Rocky](https://rockylinux.org/download) <br />
[Arch](https://archlinux.org/download/) <br />
[Fedora](https://fedoraproject.org/) <br />
[Windows Server 2022](https://www.microsoft.com/en-us/evalcenter/download-windows-server-2022) <br />
[Windows Server 2019](https://www.microsoft.com/en-us/evalcenter/download-windows-server-2019)<br />
[Windows 11 Desktop](https://www.microsoft.com/software-download/windows11)<br />
[Windows 10 Desktop](https://www.microsoft.com/en-us/software-download/windows10ISO)<br />
[VirtIO Driver](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso) - **Is needed for Windows Vms** <br />

[TrueNAS Scale](https://www.truenas.com/download-truenas-scale/) <br />
[TrueNAS Core](https://www.truenas.com/download-truenas-core/)<br />

## Install a VM

#### Linux VM
Click on `Create VM` in the top right of the webUI 
- Click `Advanced` box to see the `start at boot` option
- Give the VM a Name 
- Select an ISO image that you would like to use and make sure the `Guest OS` type matches the ISO
- The amount of disk space, RAM, and CPUs will depend on what the server will be used for. I reccomend inspecting the projects documentation for hardware requirements
- Verify configuration and select `start after created` if you want the vm to boot when you are done the configuration

#### Windows VM
You need to download this [VirtIO Driver](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso) ISO to make windows VMs work in proxmox (will be used after the initial setup)
- Give the VM a Name
- Click `Advanced` box to see the `start at boot` option
- Select an ISO image that you would like to use and make sure the `Guest OS` type matches the ISO, and make sure the version is correct (10 or 11, ect..)
- select scsi controller: `VirtIO SCSI single`
- Click `Add additional drive for VirtIO drivers` option in the `OS` menu
- Select the `UEFI` option in System > BIOS, then add the location for storage
- Click `Qemu Agent` and also select `TPM v2.0` and select the storage for both ofd those options
- In `scsi bus` would reccommended atleast 64G of disk space
- Atleat 2 CPUs (Cores), then in the `Type:`select `host` 
- Atleast 4g of RAM
- Verify configuration and select `start after created` if you want the vm to boot when you are done the configuration

This should be all you need to create awindows VM - there is a way to add a NVidia GPU to this VM (Showing you how to add PCI/GPU passthrough below)

## Create backups using Proxmox Backup Server 
You need to Download the [Proxmox Backup Server](https://www.proxmox.com/en/downloads) and it is reccommended that you do not have the server on the host that you are backing up
The steps for installing the backup server are pretty much the same as the proxmox VE.

#### Update and upgrade Server 
- Navigate to `Administration` > `Repositories` and then click `Add` and select the `No-Subscription` option in the drop down menu
- Navigate to `Administration` > `Updates` and `Refresh` the repositories. Then select `Upgrade` to upgrade the packages

#### Create backup storage space
- Navigate to Storage / Disks amd select `Directory`
- Select an unused Disk and select the disk formate, and give this a name. Set this as a datastore

#### Create a backup user
- Navigate to `Acess Control` and create a user by clicking `add`. This will only be going to be used for backups. I make a user named `backup`.
- Navigate to `Acess Control` > `Permissions` and click `Add` > `User Permission` and select the datastore that was created previously, and set the permissions to `Datastore Admin`
- On the Dashboard click the `Show Fingerprint` on the top of the screen, and keep this as we will need to enter this in proxmox VE.

Go to the Proxmox VE installation and navigate to `Datacenter > Storage`. Click the `Add` button and select `Proxmox Backup Server`.
- Give this a name (`ID`)
- Put the proxmox backup server IP in he `server` section
- set the username nad password sections to the backup user that was created on the proxmox backup server
- copy/paste the fingerprint from the proxmox backup server in the `Fingerprint` section
- Enter the name of the datastore that was created on the proxmox backup server 

Navigate to the `Backup` tab in the menu and click `Add`. here you can specify what, when, where and how to back up the VMs. You can set the retention of the backups and intervals.

## PCI / GPU Passthrough

## Proxmox Helper scripts
These are some script to assist in creating services on proxmox from [tteck.](https://tteck.github.io/Proxmox/)
- You run these in the proxmox host shell, and the intructions are on the site
