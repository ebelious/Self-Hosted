Auto-Mount SMB Share on Boot
- Make a mount directory on the system for the SMB share to mount to 
- modify `/etc/fstab`

``` 
# smb mount
//SHARE IP/SHARE /mnt/SHARE cifs credentials=/home/USER/.smbcredentials,uid=1000,gid=1000,x-gvfs-show  0 0 
```
This mounts the network share to the specified directory and uses the file using CIFS and uses the specified file for the credential access, then added user and group permissions to access this directory, and allowed this to be seen in file manager

The credential `.smbcredentials` file looks like this:
```
username=example
password=example
domain=example
```
The name of the files does not matter, but I like to have this as a hidden file. You only want the user to be able to read,write to this file. There is no execution needed on this file.

Make sure the directory matches the permissions of the UID and GID in the fstab file.
``chmod 0600 .smbcredentials``

You can run this command to mount the drive(s) and reference fstab flie
`sudo mount -a` 
