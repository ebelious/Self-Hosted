# Quick Install for Wazuh - [Quick Install](https://documentation.wazuh.com/current/quickstart.html)

```
curl -sO https://packages.wazuh.com/4.8/wazuh-install.sh && sudo bash ./wazuh-install.sh -a
```
Once the assistant finishes the installation, the output shows the access credentials and a message that confirms that the installation was successful.

```
INFO: --- Summary ---
INFO: You can access the web interface https://<wazuh-dashboard-ip>
    User: admin
    Password: <ADMIN_PASSWORD>
INFO: Installation finished.
You now have installed and configured Wazuh.

Access the Wazuh web interface with https://<wazuh-dashboard-ip> and your credentials:

username: admin
Password: <ADMIN_PASSWORD>
```

When you access the Wazuh dashboard for the first time, the browser shows a warning message stating that the certificate was not issued by a trusted authority. This is expected and the user has the option to accept the certificate as an exception or, alternatively, configure the system to use a certificate from a trusted authority.

Note You can find the passwords for all the Wazuh indexer and Wazuh API users in the wazuh-passwords.txt file inside wazuh-install-files.tar. To print them, run the following command:
```
sudo tar -O -xvf wazuh-install-files.tar wazuh-install-files/wazuh-passwords.txt
```
If you want to uninstall the Wazuh central components, run the Wazuh installation assistant using the option `-u` or `–-uninstall`

---

# Install Agents

You may want to configure endpoint groups to make configuration changes to different operating systems easier. This will allow a single config to be made for all endpoints in those groups saving time and effort. ``

Go to `Server Management` in the left panel menu
- `Endpoint Groups` to create and edit groups
- `Endpoint Summary` to create and edit all endpoints

Select `Deploy New Agent`. This will bring up a bnew screen where you can pick an operating system. There is additional supported opperating systems listed in this [Documentation](https://documentation.wazuh.com/current/installation-guide/packages-list.html) and also some manual additions for the wazuh [Repos](https://documentation.wazuh.com/current/installation-guide/wazuh-agent/wazuh-agent-package-linux.html)

You will fill out the following to get the comand to execute below on the hosts

- Server address: This is the WAzuh management server you would like the agent to comuniucate with
- Optional settings: This is where you enter the agent name and endpoint group

After you fill out the informartion in these sections the commnand is displayed 

Example: 
```
wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.8.0-1_amd64.deb && sudo WAZUH_MANAGER='10.1.1.9' WAZUH_AGENT_GROUP='Linux_Server' WAZUH_AGENT_NAME='test' dpkg -i ./wazuh-agent_4.8.0-1_amd64.deb
```

After you run the comand to install the agent you would then reload all the daemons and enable the service to start on system boot, and to start the service now.
```
sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
```
The agent then will relay and load all information the the designated Wazuh Server 
You can see this information in the `Endpoint Summary` section

---

# Enable Syslog

This [Documentation](https://documentation.wazuh.com/current/user-manual/capabilities/log-data-collection/syslog.html) shows how to integrate syslog functionality to Wazuh.

Go to `Server Management` > `Settings` and here you will be able to modify the Wazuh Manager config file

Select `Edit Configuration` on the top right of the screen

Add this configuration. 
```
<remote>
  <connection>syslog</connection>
  <port>514</port>
  <protocol>tcp</protocol>
  <allowed-ips>192.168.2.15/24</allowed-ips>
  <local_ip>192.168.2.10</local_ip>
</remote>
```
Set the port for the syslog communication and either TCP or UDP.
Make sure you set the allowed networks or address' that are allowed to send syslog messages to the server. 
Set the Local IP to the IP of the Wazuh Management Server 

When any changes are made on the Wazuh Manager configuration the changes need to be saved and the service needs to be restarted 
```
systemctl restart wazuh-manager
```

---

# Remove Agents from Wazuh Manager 

This is the [Documentaiton](https://documentation.wazuh.com/current/user-manual/agent/agent-management/remove-agents/remove.html) to remove an agent from the Manager via CLI

SSH into Wazuh Server and execute the command below

```
sudo /var/ossec/bin/manage_agents
```

This will show the commands that can be ran including adding, extracting a key, listing, and removing agents.

```
****************************************
* Wazuh v4.8.0 Agent manager.          *
* The following options are available: *
****************************************
   (A)dd an agent (A).
   (E)xtract key for an agent (E).
   (L)ist already added agents (L).
   (R)emove an agent (R).
   (Q)uit.
Choose your action: A,E,L,R or Q: L
```

Run this command above and then select `r` and then enter the agent ID to remove the specifiec agent.

