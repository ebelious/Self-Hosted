## Instructions to install a SOC Stack
This is a write-up for installing the all-in-one SOC stack using free and open-source tools which is greatly improved by integrating the tools with a project by  [socfortress](https://github.com/socfortress/CoPilot). This incorporates many of the open-source tools we all love to use and allows you to utilize the benefits of each in a single pane of glass. Just as a heads up, this may require a large amount of resources to run as many parts are running on one machine. Most of the credit goes to SocFortress for the guides and tool they created

** Note: This may be best used as a lab environment and not in production

1. Install Ubuntu 22.04
2. Install Mongodb (5.0+)
3. Install Wazuh (opensearch)
4. Install Graylog
5. Install Fluent Bit
6. Install Velociraptor
7. Install Grafana
8. Install InfluxDB
9. Install Telegraf
10. Install [Soc-Fortress Copilot](https://github.com/socfortress/CoPilot)

---

Flow:

```
                                                               Data Enrichment         Wazuh Dashboard
                                                                     ^                        ^  
                                                                     |                        |         ----------> Grafana 
                                                                     v                        v        |              |
Wazuh Endpoints Agents ---> Wazuh Manager -----> Fluent-bit -----> Graylog -----> Wazuh Indexer (Opensearch) -----> CoPilot (Connnects to Wazuh Manager and Indexer individualy)
                                                                     ^  \                                             ^   |
Syslog Devices ------------------------------------------------------|   (MongoDB used for Graylog)                   |   |
                                                                                                                      |   -----> InfluxDB
Velociraptor ---------------------------------------------------------------------------------------------------------|              ^
                                                                                                                                     |
Telegraf ----------------------------------------------------------------------------------------------------------------------------|

```

---
#### ** Upadate:
Socfortress releaed a docker-compose for this stack 
[OSSIEM](https://github.com/socfortress/OSSIEM)

## Install Ubuntu 22.04 on a VM (or hardware if you are daring enough)
- The size of this VM may be dependent on the resources you have to add to the machine
- The same with disk space would depend on how many logs you're ingesting <\br>
** Note: I would probably be safe with min 12-16G of mem and 2-4 cpu
```
sudo sysctl -w vm.max_map_count=262144
echo 'vm.max_map_count=262144' | sudo tee -a /etc/sysctl.conf
```

## Install Mongodb 5.0+
This will install mongodb 6.0, the process would be the same for different versions, but you need to locate that repo instead pf 6.0. 
Note: There is a CPU requirement for mongodb 5.0+ (AVX support)
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
```
sudo apt-mark hold mongodb-org
```

---

## Install [Wazuh 4.9](https://documentation.wazuh.com/current/quickstart.html)(open search)
For this, I use the quick install script 
```
curl -sO https://packages.wazuh.com/4.9/wazuh-install.sh && sudo bash ./wazuh-install.sh -a
```

Then we will modify memory usage for the Wazuh Indexer
```
sudo nano /etc/wazuh-indexer/opensearch.yml
```
add this line somewhere in the config (opensearch.yml)
** Note - when addding this, it seemed to create issues starting the service
```
bootstrap.memory_lock: true
```
Also, make sure the network host is like this `network.host: "0.0.0.0"`


We will open this file and add the memory lock line in the `Service` section
```
nano /usr/lib/systemd/system/wazuh-indexer.service
```
```
LimitMEMLOCK=infinity
```
For this, you do not want to exceed 50% of the total memory on the machine 
```
nano /etc/wazuh-indexer/jvm.options
```
edit the `-Xms4g` and `-Xmx4g` values to not be above half of the memory (needs matching values)
```
sudo systemctl daemon-reload
sudo systemctl restart wazuh-indexer
```

Change the IPs of the server in the wazuh config to match the IP you will be accessing this from by editing`/etc/wazuh-dashboard/wazuh-dashboards.yml`

Sign in and create the user for Graylog and Copilot
`Index Management > Internal users` add (recommended to use alpha-numeric password only)
graylog - backend role: admin


and now a user for `copilot`

Go into add new `permissions`. Then you will click `create action group` in the cluster permissions
click `create new action group > from blank` and name this `copilot_action_group` 


Add the following
```
indices_all

kibana_all_read

read

cluster_monitor

```
Then go to roles and add new `roles`.
```
name: copilot
password: create_one
cluster permissions: copilot
index: *
index permissions: read index indices_all
```

then map `copilot` user to this role, nothing else is needed

You can also generate agents on your devices

---

## Install [Graylog 6.0](https://go2docs.graylog.org/current/downloading_and_installing_graylog/ubuntu_installation.html)

prereqs:
```
sudo apt install apt-transport-https openjdk-11-jre-headless uuid-runtime dirmngr
```

Download and install Graylog
```
wget https://packages.graylog2.org/repo/packages/graylog-6.0-repository_latest.deb
sudo dpkg -i graylog-6.0-repository_latest.deb
sudo apt-get update
sudo apt-get install graylog-server
```
```
sudo apt-mark hold graylog-server
```

Now we will create a password for the admin user and also generate a hash. May be good to put these in a text editor

password secret
```
< /dev/urandom tr -dc A-Z-a-z-0-9 | head -c${1:-96};echo;
```
root sha hash
```
echo -n "Enter Password: " && head -1 </dev/stdin | tr -d '\n' | sha256sum | cut -d" " -f1
```
Add these to `/etc/graylog/server/server.conf` in their respective places `elasticsearch_hosts`

While we are here we will also place the server IP address in the HTTPS configuration section
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

So from here we will need to create a directory for the SSL certifiactes to allow gray log to communicate with opensearch
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

Access via the web: `http://IP:9000`
go to `System` > `Users and Teams` > `Create user`
Create `copilot` user 
- Select session never expires
- create password

---

## Install FluentBit

For this, we will not be using filebeat, but fluent-bit. We will disable and stop the filebeat service.
```
sudo systemctl disable filebeat
sudo systemctl stop filebeat
```

Install fluent-bit
```
curl https://raw.githubusercontent.com/fluent/fluent-bit/master/install.sh | sh
```

remove all the contents of `/etc/fluent-bit/fluent-bit.conf` and add this

**Modify the port and IP 

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

This is installing version 0.72, there are other releases on their github 
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

Edit the `server.config.yml` and change the GUI bind address to the server IP

Then we will create the deb package for the server binary to install 
```
./velociraptor-v0.6.4-2-linux-amd64 --config server.config.yaml debian server --binary 
```

Install the server binary
```
dpkg -i velociraptor_server_0.72.1_amd64.deb
```

We will then create a debian server client package and also rpm package
** Note: modify the server URL to match the server IP

```
./velociraptor-v0.72.1-linux-amd64 --config client.config.yaml debian client
```
```
./velociraptor-v0.72.1-linux-amd64 --config client.config.yaml rpm client
```

Generate Windows client, download .exe from repo, repack linux into exe
```
wget https://github.com/Velocidex/velociraptor/releases/download/v0.72/velociraptor-v0.72.1-windows-amd64.exe

./velociraptor-v0.72.1-linux-amd64 config repack --exe velociraptor-v0.72.1-windows-amd64.exe client.config.yaml velociraptor-v0.72.1-windows.exe
```

transfer new .exe and install on Windows client (user scp or sftp to transfer - may be easiest) 
```
.\velociraptor-v0.72.1-windows.exe service install  
```


Create an API config for copilot to connect

```
./velociraptor-v0.72.1-linux-amd64 --config server.config.yaml config api_client --name NAME_VALID_USER --role administrator,api api.config.yaml
```

Can connect `https://<IP>:8889`

---

## Install Grafana

```
sudo apt-get install -y apt-transport-https
sudo apt-get install -y software-properties-common wget
sudo wget -q -O /usr/share/keyrings/grafana.key https://apt.grafana.com/gpg.key
```
```
echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
```
```
sudo apt-get update
sudo apt-get install grafana
```
```
mkdir /etc/grafana/certs
cp /etc/wazuh-indexer/certs/wazuh-indexer.pem /etc/grafana/certs/
cp /etc/wazuh-indexer/certs/wazuh-indexer-key.pem /etc/grafana/certs/
```
Modify the `/etc/grafana/grafana.ini` file

in the `[server]` config make sure these are set (remove ';')

```
protocol = https
domain = localhost

cert_file = /etc/grafana/certs/wazuh-indexer.pem
cert_key = /etc/grafana/certs/wazuh-indexer-key.pem
```
```
sudo chown -R grafana:grafana /etc/grafana/certs/
```
log into web UI `https://SERVER_IP:3000`
`admin:admiin`

Will be prompted to change password

go to `Administration` > `Users` and create the copilot user

```
copilot
admin: yes
```

---

## Install InfluxDB

```
wget -q https://repos.influxdata.com/influxdata-archive_compat.key
echo '393e8779c89ac8d958f81f942f9ad7fb82a25e133faddaf92e15b16e6ac9ce4c influxdata-archive_compat.key' | sha256sum -c && cat influxdata-archive_compat.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg > /dev/null
echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg] https://repos.influxdata.com/debian stable main' | sudo tee /etc/apt/sources.list.d/influxdata.list

sudo apt-get update && sudo apt-get install influxdb2

sudo systemctl enable influxdb
sudo systemctl start influxdb
sudo systemctl status influxdb
```

Conect `http://<IP>:8086`

generate a token for telegraf
- Load Data > API Tokens > Custom API Token >
      Telegrafs (select `write` and `read`, provide a `name` for the token), keep note of this as this is used for telegraph config
      Buckets > telegraf (`read` and `write`)                                        
Also Create an API token for Copilot, this will be only read access `Bucketrs: all buckets` and `Other resources: All Checks, and All Orgs`

Again keep note of these API keys as you will note able to see them again 

---

## Install Telegraf
```
wget -q https://repos.influxdata.com/influxdata-archive_compat.key
echo '393e8779c89ac8d958f81f942f9ad7fb82a25e133faddaf92e15b16e6ac9ce4c influxdata-archive_compat.key' | sha256sum -c && cat influxdata-archive_compat.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg > /dev/null
echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg] https://repos.influxdata.com/debian stable main' | sudo tee /etc/apt/sources.list.d/influxdata.list
sudo apt-get update && sudo apt-get install telegraf
```
We then will modify the `/etc/telegraf/telegraf.conf`

Modify: URLs, token, organization ()token is generated in influx db
```
#### Telegraf Configuration - Linux Agents
#
# SOCFortress, LLP, info@socfortress.co
#
####
[global_tags]
[agent]
  interval = "10s"
  round_interval = true
  metric_batch_size = 1000
  metric_buffer_limit = 10000
  collection_jitter = "0s"
  flush_interval = "10s"
  flush_jitter = "0s"
  precision = ""
  logtarget = "file"
  logfile = "/var/log/telegraf/telegraf.log"
  logfile_rotation_interval = "1d"
  logfile_rotation_max_archives = 5
  hostname = ""
  omit_hostname = false
[[outputs.influxdb_v2]]
   urls = ["http://*REPLACE*:8086"]
   token = "*PASS*"
   organization = "ORG"
   bucket = "telegraf"
[[inputs.cpu]]
  percpu = true
  totalcpu = true
  collect_cpu_time = false
  report_active = false
[[inputs.disk]]
  ignore_fs = ["tmpfs", "devtmpfs", "devfs", "iso9660", "overlay", "aufs", "squashfs"]
[[inputs.diskio]]
[[inputs.kernel]]
[[inputs.mem]]
[[inputs.processes]]
[[inputs.swap]]
[[inputs.system]]
[[inputs.net]]
[[inputs.procstat]]
  pattern = ".*"
[[inputs.systemd_units]]
  ## Set timeout for systemctl execution
   timeout = "1s"

  # Filter for a specific unit type, default is "service", other possible
  # values are "socket", "target", "device", "mount", "automount", "swap",
  # "timer", "path", "slice" and "scope ":
  unittype = "service"

  # Filter for a specific pattern, default is "" (i.e. all), other possible
  # values are valid pattern for systemctl, e.g. "a*" for all units with
  # names starting with "a"
  pattern = ""
```

```
sudo systemctl enable telegraf
sudo systemctl start telegraf
sudo systemctl status telegraf
```

Now that influxdb and telegraf are configured, we will need to configure influx db to show us the proper data 



---


## Install [CoPilot](https://github.com/socfortress/CoPilot)

grab the repo from their github
```
git clone https://github.com/socfortress/CoPilot.git
cd CoPilot
cp .env.example .env
```
edit the `.env` file and add passwords the the `REPLACE_ME` sections and add the server IP to the `ALERT_FORWARDING`

Edit the docker-compose.yml and edit the host port for copilot-frontend to a nondefault port, also do the same for the minio container host port.

```
docker-compose up -d
```

To get the `admin` credentials for the GUI we need to run this command. The `plain` value is the password we need
```
docker logs "$(docker ps --filter ancestor=ghcr.io/socfortress/copilot-backend:latest --format "{{.ID}}")" 2>&1 | grep "Admin user password"
```

Now we will add the connections we need to CoPilot.
```
wazuh-indexer: copilot user - port 9200
wazuh-manager: wazuh-wui user - port 55000
graylog - copilot user - port 9000
grafana - admin user - port 3000
velociraptor - api.config.yaml
influxdb - - port 8086
```



Now we will create a customer. You can name this whatever you want the input copilot requires

On the `overview` dashboard, select `stack provisioning` and `deploy`

Then select the customer you created in the `customers` click `details` and provision the customer


---

---

- Add agents to the `Linux_<customer>` or `Windows_<customer>` depending on OS
- Add GeoLiteDB to graylog
- 
