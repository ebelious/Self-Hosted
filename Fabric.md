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

If you want to integrate this with Google, Claude, or Youtube, you would need to get the API keys at this point before running the configuration
- For Google and Youtube you would need to go to [Google Cloud](https://console.cloud.google.com/) and create an account if you dont already have one
- Create a Project in Google Cloud
![Google Cloud Project](https://github.com/ebelious/Self-Hosted/blob/main/Images/Screenshot%20from%202024-07-12%2016-31-29.png)
- On the project dashboard, click Explore & Enable APIs and select `YouTube Data API v3`. Enable this API and and create the credentials. Save the API key, and you also do this same thing for google. You can use the same project.
![Credentials-api](https://github.com/user-attachments/assets/749172c5-57ee-404a-8326-3ced35607f8b)
![Enable API](https://github.com/ebelious/Self-Hosted/blob/main/Images/Screenshot%20from%202024-07-12%2016-43-27.png)
After you collect the API keys you run this:
```
fabric --setup
```
