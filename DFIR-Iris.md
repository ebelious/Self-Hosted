![iris](https://docs.dfir-iris.org/_static/logo-white.png)
## This [Documentation](https://docs.dfir-iris.org/getting_started/) on how I installed iris v2.4.7 on Ubuntu 22.04

### Hardware Requirements:
```
CUP: 4 cores
RAM: 8Gb
HDD: Not Specified (I added 64 Gb)
```

### Clone the iris-web repository:
```
git clone https://github.com/dfir-iris/iris-web.git
cd iris-web
```
### Check out the latest non-beta tagged version:
```
git checkout v2.3.7
```
### Copy the environment file
Modify the password and salt keys`.env` file to avoid auth bypass issues.
```
cp .env.model .env
```

Note: This will error on the Pip version in the container. You will need to run this before building. (I ran  the commands in the git directory not tmp)
```
# cd /tmp/dfiriris
cp docker/webApp/Dockerfile docker/webApp/Dockerfile.orig.`date -I`
sed s',pip3 install -r requirements.txt,pip3 install --upgrade pip \&\& pip3 install -r requirements.txt,' -i docker/webApp/Dockerfile
```

### Build the Docker containers:
```
docker-compose build
```
### Start IRIS:
```
docker-compose up -d
```

### Signing in
Look at the logs to get the `administrator` password.
```
docker compose logs <CONTAINER ID> | grep 'admin'
```
You should see your password her between the `>>>` and `<<<`:
```
 :: INFO :: post_init :: run_post_init :: You can now login with user administrator and password >>> PASSWORD <<< on 443
```
