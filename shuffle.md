![shufffle](https://shuffler.io/images/logos/topleft_logo.svg)

## This is a SOAR (Security orchestration automation and response) platform used commonly with Wazuh, MISP, Virustotal, ect.


### [Installation](https://github.com/shuffle/shuffle/blob/main/.github/install-guide.md) is simple. This runs in a docker container and is formed via docker-compose
```
git clone https://github.com/Shuffle/Shuffle
cd Shuffle
mkdir shuffle-database
sudo chown -R 1000:1000 shuffle-database
sudo swapoff -a
docker compose up -d
sudo sysctl -w vm.max_map_count=262144     (for VMs)
```
When logging in you will need to create a new account
```
http://<IP>:3001
```

This is some [Geting Started](https://shuffler.io/docs/getting_started) documentation

There are additional apps you can get by signing into your account on [shuffle.io] and searching in the search menu.
I added these to a local instance by Activating the App, downloading the YAML file, and then importing this to my local instanace
