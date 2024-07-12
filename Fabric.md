# Install Dependancies

### Debian/Ubuntu
```
sudo apt install pipx
```
### RedHat/Fedora
```
sudo dnf install pipx
```
# Download Repo from [fabric](https://github.com/danielmiessler/fabric)

```
git clone https://github.com/danielmiessler/fabric.git
```

```
cd fabric
```
```
pipx install .
```
May have to ensure path `pipx ensurepath`

# Configure fabric

If you want to integrate this with Google, claude, or Youtube, you would need to get the APIs at this point before rnning the configuration
- For Google and youtube you would need to go to [Google Cloud](https://console.cloud.google.com/) and create an account if you dont already have one
- Creatge a Project
![Google Cloud Projecrt](https://github.com/ebelious/Self-Hosted/blob/main/Images/Screenshot%20from%202024-07-12%2016-31-29.png)


```
fabric --setup
```
