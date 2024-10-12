## Instructions to install a SOC Stack
This is a write up for installing the all-in-one SOC stack using free and open source tools which is greatly improved by integrating the tools with a project by  [socfortress](https://github.com/socfortress/CoPilot). This integrates a lot of the opensource tools we all love to use and allows you to utilize the benefits of each in a single pane of glass.

** Note: This may be best used as a lab enviroment and not production

1. Install Ubuntu 22.04
2. Install Mongodb (5.0+)
3. Install Wazuh (opensearch)
4. Install Graylog
5. Install Fluent Bit
6. Install Velociraptor
7. Install Grafana
8. Install [Soc-Fortress Copilot](https://github.com/socfortress/CoPilot)

---

## Install Ubuntu 22.04 on a vm (or hardware if youre daring enough)
- The size of this vm may be dependant oin the resources you have to add to the machine
- same with disk space would depend on how many llogs youre injesting
```
sudo sysctl -w vm.max_map_count=262144
echo 'vm.max_map_count=262144' | sudo tee -a /etc/sysctl.conf
```

## Install Mongodb 5.0+
This will install mongodb 6.0, the process would be the same for different versions, but you need to locate that repo instead pf 6.0. 
Note: There is a cpu requuirement for mongodb 5.0+ (AVX support)
```
sudo apt update
```
```
sudo apt install git curl gnupg docker docker-compose wget
```
```
curl -fsSL https://www.mongodb.org/static/pgp/server-6.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg \
   --dearmor
```
```
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
```
```
sudo apt-get update
```
```
sudo apt-get install -y mongodb-org

```
```
sudo systemctl daemon-reload
sudo systemctl enable mongod.service
sudo systemctl restart mongod.service
sudo systemctl --type=service --state=active | grep mongod
```

---

## Install [Wazuh 4.9](https://documentation.wazuh.com/current/quickstart.html)(open search)
For this I use the quick install script 
```
curl -sO https://packages.wazuh.com/4.9/wazuh-install.sh && sudo bash ./wazuh-install.sh -a
```

Then we will modify memory useage for the Wazuh Indexer
```
sudo nano /etc/wazuh-indexer/opensearch.yml
```
add this line somewhere in the config (opensearch.yml)
```
bootstrap.memory_lock: true
```
Also make sure the network host is like this `network.host: "0.0.0.0"`


We will open this file and add the meomry lock line in the `Service` section
```
nano /usr/lib/systemd/system/wazuh-indexer.service
```
```
LimitMEMLOCK=infinity
```
For this you do not want to exceed 50% of the total memory on the machine 
```
nano /etc/wazuh-indexer/jvm.options
```
edit the `-Xms4g` and `-Xmx4g` value to not be above half of the memory
```
sudo systemctl daemon-reload
sudo systemctl restart wazuh-indexer
```

Change the IPs of the server in the wazuh config to match the IP you will be accessing this from by editing`/etc/wazuh-dashboard/wazuh-dashboards.yml`

Sign in and create the user for Graylog and Copilot
`Index Management > Internal users` add (reccomended to use alpha-numeric password only)
graylog - backend role: admin


and now a user for `copilot`

Go int oadd new `permissions`. Then you will click `create action group` in the cluster permissions
click `create new action group > from blank` and name this `copilot_action_group` 


Add the following
```
indices_all

kibana_all_read

read

cluster_monitor

```
Then go to roles and add a new `roles`.
```
name: copilot
password: create_one
cluster permissions: copilot
index: *
index permissions: read index indices_all
```

then map `copilot` user to this role, nothing else is needed

---

## Install [Graylog 6.0](https://go2docs.graylog.org/current/downloading_and_installing_graylog/ubuntu_installation.html)

prereqs:
```
sudo apt install apt-transport-https openjdk-11-jre-headless uuid-runtime dirmngr
```

Download and install graylog
```
wget https://packages.graylog2.org/repo/packages/graylog-6.0-repository_latest.deb
sudo dpkg -i graylog-6.0-repository_latest.deb
sudo apt-get update
sudo apt-get install graylog-server
```
```
sudo apt-mark hold graylog-server
```

Now we will creata a password for the admin user and also generate a hash. May be good to put these in a text editor

password secret
```
< /dev/urandom tr -dc A-Z-a-z-0-9 | head -c${1:-96};echo;
```
root sha hash
```
echo -n "Enter Password: " && head -1 </dev/stdin | tr -d '\n' | sha256sum | cut -d" " -f1
```
Add these to `/etc/graylog/server/server.conf` in their respective places `elasticsearch_hosts`

While we are in here we will also place the server IP address in the HTTPS configuration section
```
elasticsearch_hosts = https://USER:PASSWORD@127.0.0.1:9200
```
```
http_bind_address = 0.0.0.0:9000
```

```
sudo systemctl daemon-reload
sudo systemctl enable graylog-server.service
sudo systemctl start graylog-server.service
sudo systemctl --type=service --state=active | grep graylog
```

So form here we will need to create a directory for the SSL certifiactes to allow gray log to communicate with opensearch
```
mkdir /etc/graylog/server/certs
cp /etc/wazuh-indexer/certs/root-ca.pem /etc/graylog/server/certs/
cp -a /usr/lib/jvm/java-11-openjdk-amd64/lib/security/cacerts /etc/graylog/server/certs/cacerts
keytool -importcert -keystore /etc/graylog/server/certs/cacerts -storepass changeit -alias root_ca -file /etc/graylog/server/certs/root-ca.pem
```
Add the following under the section `Fix for log4j CVE-2021-44228` and coment out hte line that is already present in `/etc/default/graylog-server`
```
GRAYLOG_SERVER_JAVA_OPTS="$GRAYLOG_SERVER_JAVA_OPTS -Dlog4j2.formatMsgNoLookups=true -Djavax.net.ssl.trustStore=/etc/graylog/server/certs/cacerts -Djavax.net.ssl.trustStorePassword=changeit"
```

Access via web: `http://IP:9000`
go to `System` > `Users and Teams` > `Create user`
Create `copilot` user 
- Select session never expires
- create password

---

## Install FluentBit

For this we will not be using filebeat, but fluent-bit. We will disable and stop the filebeat service.
```
sudo systemctl disable filebeat
sudo systemctl stop filebeat
```

Install fluent-bit
```
curl https://raw.githubusercontent.com/fluent/fluent-bit/master/install.sh | sh
```

remove all the contents of `/etc/fluent-bit/fluent-bit.conf` and add this 

```
[SERVICE]
    flush        5
    daemon       Off
    log_level    info
    parsers_file parsers.conf
    plugins_file plugins.conf
    http_server  Off
    http_listen  0.0.0.0
    http_port    2020
    storage.metrics on
    storage.path /var/log/flb-storage/
    storage.sync normal
    storage.checksum off
    storage.backlog.mem_limit 5M
    Log_File /var/log/td-agent-bit.log
[INPUT]
    name  tail
    path  /var/ossec/logs/alerts/alerts.json
    tag wazuh
    parser  json
    Buffer_Max_Size 5MB
    Buffer_Chunk_Size 400k
    storage.type      filesystem
    Mem_Buf_Limit     512MB
[OUTPUT]
    Name  tcp
    Host  *your graylog host*
    Port  *your graylog port*
    net.keepalive off
    Match wazuh
    Format  json_lines
    json_date_key true
```

Start fluent-bit
```
systemctl enable fluent-bit
systemctl start fluent-bit
```

---

## Install [Velociraptor](https://github.com/Velocidex/velociraptor)

This is installing the version 0.72, there is other releases on thier github 
```
wget https://github.com/Velocidex/velociraptor/releases/download/v0.72/velociraptor-v0.72.1-linux-amd64
```
```
chmod +x velociraptor-v0.72.1-linux-amd6
```

This will run the interactive configuration
```
./velociraptor-v0.72.1-linux-amd6 config generate -i
```

Edit the `server.config.yml` and change the GUI bind address to the servers IP

Then we wil create the deb package for ther server binary to install 
```
./velociraptor-v0.6.4-2-linux-amd64 --config server.config.yaml debian server --binary 
```

Install the server binary
```
dpkg -i velociraptor_server_0.72.1_amd64.deb
```

We will then create a debian server client package anmd also rpm package

```
./velociraptor-v0.72.1-linux-amd64 --config client.config.yaml debian client
```
```
./velociraptor-v0.72.1-linux-amd64 --config client.config.yaml rpm client
```

Creat an api config for copilot to connect

```
./velociraptor-v0.72.1-linux-amd64 --config server.config.yaml config api_client --name NAME_VALID_USER --role administrator,api api.config.yaml
```

---

## Install Grafana


---


## Install [CoPilot](https://github.com/socfortress/CoPilot)

grab the rpo from their github
```
git clone https://github.com/socfortress/CoPilot.git
cd CoPilot
cp .env.example .env
```
edit the `.env` file and add passwords the the `REPLACE_ME` sections and add ther servers IP to the `ALERT_FORWARDING`IP

Edit the docker-compose.yml and edit the host port for copilot-frontend to a non default port, also do the same for the minio contianer host port.

```
docker-compose up -d
```

To get the `admin` credentials forthe GUI we need to run this command. The `plain` value is the password we need
```
docker logs "$(docker ps --filter ancestor=ghcr.io/socfortress/copilot-backend:latest --format "{{.ID}}")" 2>&1 | grep "Admin user password"
```

Now we will add our connections we need to CoPilot.
```
wazuh-indexer: copilot user - port 9200
wazuh-manager: wazuh-wui user - port 55000
graylog - copilot user - port 9000
grafana - admin user - port 3000
velociraptor - api.config.yaml
```
