

#Quick Install for Wazuh - [Quick Install](https://documentation.wazuh.com/current/quickstart.html)

```
curl -sO https://packages.wazuh.com/4.8/wazuh-install.sh && sudo bash ./wazuh-install.sh -a
```
Once the assistant finishes the installation, the output shows the access credentials and a message that confirms that the installation was successful.


INFO: --- Summary ---
INFO: You can access the web interface https://<wazuh-dashboard-ip>
    User: admin
    Password: <ADMIN_PASSWORD>
INFO: Installation finished.
You now have installed and configured Wazuh.

Access the Wazuh web interface with `https://<wazuh-dashboard-ip>` and your credentials:

`Username: admin`
`Password: <ADMIN_PASSWORD>`


When you access the Wazuh dashboard for the first time, the browser shows a warning message stating that the certificate was not issued by a trusted authority. This is expected and the user has the option to accept the certificate as an exception or, alternatively, configure the system to use a certificate from a trusted authority.

Note You can find the passwords for all the Wazuh indexer and Wazuh API users in the wazuh-passwords.txt file inside wazuh-install-files.tar. To print them, run the following command:
```
sudo tar -O -xvf wazuh-install-files.tar wazuh-install-files/wazuh-passwords.txt
```
If you want to uninstall the Wazuh central components, run the Wazuh installation assistant using the option -u or –-uninstall.
