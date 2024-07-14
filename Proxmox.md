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

Navigate to this url with the IP you configured for the server `https://IP_ADDRESS:8006`

## Configure the community repositories



