Change hostname of device to include the domain of the AD (use your own domain info)

- ex: hostname.home.local
	`sudo hostnamectl set-hostname <hostname>`

Create or modify the following entry in the `/etc/systemd/resolved.conf` with the DNS and Domain to the IP and domain of the AD server 
```
[Resolve]
DNS=10.1.1.18 172.17.0.2 1.1.1.1 1.0.0.1
Domains=home.local
```
Restart the service and verify the service statrus after restart 
```
sudo systemctl restart systemd-resolved.service
```
```
resolvectl status
```
Make sure you have the dependencies for the AD connection 
  client-software: sssd
  required-package: sssd-common
  required-package: oddjob
  required-package: oddjob-mkhomedir
  required-package: sssd-ad
  required-package: adcli
  required-package: samba-common-tools

Add domain information to `/etc/krb5.conf` <br />
```
default_realm = HOME.LOCAL
```

```
[realms]
 home.local = {
     kdc = kerberos.home.local
     admin_server = kerberos.home.local
 }
```

Join the host to the server 
`sudo realm join -v home.local`

You can add domain user accounts to the host 

GUI:(Gnome)  `Settings` > `System` > `Users` > `Add Enterprise User`
