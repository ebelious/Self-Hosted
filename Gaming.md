#### This is the process I used when migrating from Windows to Fedora 100%

## Install Fedora
- Get the ISO from [Fedora's Website](https://fedoraproject.org/workstation/)
- Get a USB drive and use a software like [Rufus](https://rufus.ie/en/) or [Belena Etcher](https://etcher.balena.io/) to configure the USB to be a bootable drive
- Connect the USB into the PC and then either go to `BIOS/UEFI setup` or select the `Boot List` option to select the USB as the boot drive
- Follow the prompts in the Fedora installation. Make sure the you know what disk should be installing the OS on
- Make sure you enable the third party repositories in the setup process after installation (Part of the gnome tour)

## Install Nvidia GPU Drivers

Run these commands in the CLI. Reboot the system when completed
```
sudo dnf update --refresh
```
```
sudo dnf install kernel-devel kernel-headers gcc make dkms acpid libglvnd-glx libglvnd-opengl libglvnd-devel pkgconfig
```
```
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
```
```
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```
```
sudo dnf makecache
```
```
sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda
```

## Prepare Disks
 
Make a directory for the hardrive to mount to ex below. You only mount 1 drive to 1 directory. You can also make directories in the Users home directory.
```
sudo mkdir /mnt/games
```
Change the owner of the directory to the user you wil be using
```
sudo chown USER:GROUP /mnt/games
```

I had to format all of the drives that held the games. I had to start fresh.
I used the `Disks` program to do the bulk of that work as it is very fast and adds the drives to `/etc/fstab` automatically and you can choose the mount point 
Format the Disks that are going to be used. Format the disks and make a ext4 partition (As stated I used `Disks`)

The default mounting options will work fine. You would just want to change the mount point to the directory you created
![disks](https://github.com/ebelious/Self-Hosted/blob/main/Images/Screenshot%20from%202024-07-12%2020-46-16.png)


## Install Steam
There will be 2 main ways to install Steam `RPM package` or `flatpak`.
I have done research and there I cannot find conclusive answer to whuich is better, but the installs for both are equally very easy.

#### RPM Package:
sudo dnf install steam or Go to the Software application and search for steam and select the RPM version

#### Flatpak:
Go to the Software application and search for steam and select the Flatpak version
- If you install the flat pack version it would be very ideal to also instal `flatseal` which is an application to modify permissions for all flatpaks. You can modify GPU, directories, and hardware the flatpak container can access
- If there is issues locating the disk in steam, you may need to add the permiossions in `flatseal`

After you install steam, just launch the application.
- Go to Steam > Settings > Storage and click `Add Drive` from the Drop down menu and select the directory you created. It would be good to set this disk to be default.
- Go to Steam > Settings > Compatability and toggle on both `Enable Steam Play for supported titles` and `Enable Steam Play for all other titles` selectors
- Go to Steam > Settings > Downloads and toggle on `Enable Shder Pre-caching` and `Allow background processing of vulkan shaders`

From here all you need to do is install the games. Some games will not work well with certain compatability layer versions.
For both versions it may also be a good idea to downkload `ProtonUp` which will allow you to download proton-ge versions (Made by glorious eggroll) and add them to steam. You can test and see what version works best with what games.


## Install Heroic Game launcher
Go to the software app and search for `Heroic`. Down load this and then open the application.

- Go to `Manage Accounts` on the left menu and sign into the platforms you use. This should generate the games in the `Library` menu
- Go to Settings > General and select where you want to install the games, also whgere you want to install the prefixes. I usuall make a directory where the games are named `prefixes`. You can also change the app theme in this menu.

In the `Library` menu, you can install the Games, and on each game you can modify additional settings.
In the `Wine Manager` menu you can download additional compatability versions
