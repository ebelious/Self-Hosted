====================\
Date: 6/23/2024\
Topic: WinRM HTTPS Server Monitoring\
Technology: Palo Alto, Windows Server\
====================

## Windows

Assumes Windows server has AD and CA configured 

Create Service Account
	- Server Manager > Tools > Active Directory Users and Computers 
	- Create a user in the Managed Service Account

Generate Certificates
	- Run mcc
	- File > Add / remove snap-in
	- Add Certificate Authority and Certificates

Access Certificates 
	- Certificates > Personal > Certificates 
	- Look for the client authentication certificate and use the thumbrprint 
	- Look at the same certificate for the 'subject' and use the CN for the hostname

Right click on CA certificate > All Tasks > export with private key (pkcs)

Enter these commands in terminal and place the thumbprint and hostname in the last command

```
winrm set winrm/config/client/auth @{Basic="true"}
winrm set winrm/config/service/auth @{Basic="true"}
winrm set winrm/config/client/Auth @{Certificate="True"} 
winrm set winrm/config/service/Auth @{Certificate="True"} 

winrm create winrm/config/Listener?Address=*+Transport=HTTPS '@{Hostname="<hostname>"; CertificateThumbprint="<thumbprint>"}'
```


Allow the traffic inbound through the Windows Firewall on TCP port 8956

Create a service account for User-ID if this is not already created. Make sure this user is added to the groups listed:
	- Run mcc
	- File > Add / remove snap-in
	- Add Active Directory Users and Computers 
	- Navigate to Builtin folder
	
Add users to the members of these groups:
	- Distributed COM Users
	- Event Log Readers
	- Remote Management Users
	- Server Operators

Navigate to Users Folder and right click service account, deny access for Dial-in
	- Run wmimgmt
	- Right click WMI Control > Properties
	- Open Root > click on CIMV2 > Click Security
	- Add service account
	- Set permissions 'Enable Account' and 'Remote Enable'

Disable service account privileges that are not required.
	- Run gpedit
	- Navigate to Default Domain Policy > Computer Configuration > Policies > Windows Settings > Security Settings > User Rights Assignment
	- Add service account to these 
		- Deny log on as a batch job
		- Deny log on locally
		- Deny log on through Remote Desktop Services


---

## Palo Alto

Device Tab
- Certificates
	- Import the certificate with the pkcs format
	
- Certificate Profile
	- Create certificate profile with the imported certificate 

- User Identification 
	- User Mapping > User-ID Agent Setup
	- fill out the form with service account

- Server Monitoring
	- Add the AD server information > select WinRM-HTTPS
	- Connection Security > add certificate profile

-  LDAP Profile
	- Add AD server IP and port 
	- Enter Base DN and Bind DN (user@dn.dn)
	- Uncheck Require SSL/TLS connection

- Authentication Profile
	- Add LDAP profile to this profile 

Commit 


====================
## References

https://docs.paloaltonetworks.com/pan-os/10-0/pan-os-admin/user-id/map-ip-addresses-to-users/configure-user-mapping-using-the-pan-os-integrated-user-id-agent#ida08f3b63-2f96-47b2-b4af-adfe1442c2f3

https://docs.paloaltonetworks.com/pan-os/10-0/pan-os-admin/user-id/map-ip-addresses-to-users/create-a-dedicated-service-account-for-the-user-id-agent

https://knowledgebase.paloaltonetworks.com/KCSArticleDetail?id=kA14u0000001VUICA2&lang=en_US%E2%80%A9&refURL=http%3A%2F%2Fknowledgebase.paloaltonetworks.com%2FKCSArticleDetail

https://docs.paloaltonetworks.com/pan-os/10-0/pan-os-admin/user-id/map-ip-addresses-to-users/configure-server-monitoring-using-winrm#id81273367-41e0-4c72-b247-79381093cacc

====================
