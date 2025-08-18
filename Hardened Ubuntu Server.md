## Default settings for a more secure Ubuntu Server. 
This guide is used as a baseline template for all the servers using mainly CIS and Lynis - *additional action is required after the automation of CIS*

### Disk Partitions
I don't use LUKs for this, but you can obviously add encryption if needed- this is for a **64G drive**
LVM is good for scalability. When I run the Wazuh server, I'll add new partitions for the Docker containers
```
NAME                                     MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
├─sda1                                     8:1    0  512M  0 part /boot/efi
├─sda2                                     8:2    0  500M  0 part /boot
└─sda3                                     8:3    0   63G  0 part 
  ├─vg--ubuntu-lv_ubuntu_root            252:0    0   15G  0 lvm  /
  ├─vg--ubuntu-lv_ubuntu_swap            252:1    0    2G  0 lvm  [SWAP]
  ├─vg--ubuntu-lv_ubuntu_var             252:2    0   10G  0 lvm  /var
  ├─vg--ubuntu-lv_ubuntu_var_tmp             252:3    0    2G  0 lvm  /var/tmp
  ├─vg--ubuntu-lv_ubuntu_home            252:4    0   24G  0 lvm  /home
  ├─vg--ubuntu-lv_ubuntu_var_log        252:5    0    9G  0 lvm  /var/log
  └─vg--ubuntu-lv_ubuntu_var_log_audit 252:6    0    1G  0 lvm  /var/log/audit
  ```
Fstab
```
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
/dev/disk/by-id/dm-uuid-LVM-oCXUKlBUREdl93VmvopITpxShoywCJGdQdlCMUwshNFn6zNvzGIw398AsJBcQTxp none swap sw 0 0
# / was on /dev/vg-ubuntu/lv_ubuntu_root during curtin installation
/dev/disk/by-id/dm-uuid-LVM-oCXUKlBUREdl93VmvopITpxShoywCJGdEeAE217y3FWl2vvpZtEJMpsOD6LQDFcR / ext4 defaults 0 1
# /home was on /dev/vg-ubuntu/lv_ubuntu_home during curtin installation
/dev/mapper/vg--ubuntu-lv_ubuntu_home /home ext4 rw,relatime,nodev,nosuid 0 0
# /boot was on /dev/sda2 during curtin installation
/dev/disk/by-uuid/54768e92-3475-487a-ac75-1dd4c647ea99 /boot ext4 defaults 0 1
# /var was on /dev/vg-ubuntu/lv_ubuntu_var during curtin installation
/dev/mapper/vg--ubuntu-lv_ubuntu_var /var ext4 rw,relatime,nodev,nosuid 0 0
# /tmp was on /dev/vg-ubuntu/lv_ubuntu_tmp during curtin installation
/dev/mapper/vg--ubuntu-lv_ubuntu_tmp /tmp ext4 rw,relatime,nodev,nosuid,noexec 0 0
# /var/log was on /dev/vg-ubuntu/lv_ubuntu_var-log during curtin installation
/dev/mapper/vg--ubuntu-lv_ubuntu_var--log /var/log ext4 rw,relatime,nodev,nosuid,noexec 0 0
# /boot/efi was on /dev/sda1 during curtin installation
/dev/disk/by-uuid/42E1-1C32 /boot/efi vfat defaults 0 1
# /var/log/audit was on /dev/vg-ubuntu/lv_ubuntu_var-log-audit during curtin installation
/dev/mapper/vg--ubuntu-lv_ubuntu_var--log--audit /var/log/audit ext4 rw,relatime,nodev,nosuid,noexec 0 0
tmpfs /dev/shm tmpfs rw,nosuid,nodev,inode64,noexec 0 0
# /var/tmp
/dev/mapper/vg--ubuntu-lv_ubuntu_var_tmp /var/tmp ext4 rw,relatime,nodev,nosuid,noexec 0 0
```

### Security baseline software to install 
```
apparmor clamav-daemon clamav ufw
```
Start the ufw and allow only the needed ports, and set the default deny incoming traffic 
```
sudo ufw default deny incoming
sudo ufw enable
sudo ufw allow ssh
```

start apparmor 
```
sudo systemctl enable --now apparmor
```

Freshclam starts by default. Stop freshclam and run an update of signatures 
```
sudo systemctl stop clamav-freshclam
sudo freshclam
sudo systemctl enable --now clamav-freshclam
sudo systemctl enable --now clamav-daemon
```

We will also integrate clamAV with Wazuh to get any alerts generated in our Wazuh server, and also set [on-access scanning](https://docs.clamav.net/manual/OnAccess.html) of files. I just set the `/home` `/var` `/tmp` `etc` and `/opt` directories for defaults, excluding the root user
```
vim /etc/clamav/clamd.conf
```
```
LogSyslog yes
OnAccessPrevention yes
OnAccessExtraScanning yes
OnAccessExcludeUname root
OnAccessIncludePath /home
OnAccessIncludePath /opt
OnAccessIncludePath /etc
OnAccessIncludePath /var/tmp
```
Then we will run the on-access scanner for clamav to run in the background and restart the daemon
```
sudo clamonacc
sudo systemctl restart clamav-daemon
```

Can also create a nightly AV scan update using `crontab -e`. Default freshclam updates signatures hourly
```
10 2 * * * clamscan
```


### Lynis and CIS audit
Run a compliance audit and fix
Follow this [CIS](https://github.com/ebelious/Self-Hosted/blob/main/CIS-Ubuntu.md) benchmark doc for compliance 
Run the Lynis scan for additional recommendations
  - *NOTE: changes to ssh would not take in the normal sshd_conf file but they work when modifying the files in /etc/ssh/sshd_config.d/*
```
sudo apt install lynis
sudo lynis audit system
```

### Wazuh Agent
Go to the wazuh server and add an agent to the servers. Make docker listener enabled in all servers using group config
```
<wodle name="docker-listener">
  <interval>10m</interval>
  <attempts>5</attempts>
  <run_on_start>no</run_on_start>
  <disabled>no</disabled>
</wodle>
```
