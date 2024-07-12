## Install Dependancies

### Debian/Ubuntu
```
sudo apt install pipx
```
### RedHat/Fedora
```
sudo dnf install pipx
```
## Download Repo from [fabric](https://github.com/danielmiessler/fabric)

```
git clone https://github.com/danielmiessler/fabric.git
```

```
cd fabric
```
```
pipx install .
```
May have to ensure path `pipx ensurepath` and refresh terminal (open new terminal or `source ~/.bashrc` or `source ~/.zshrc`)

## Configure fabric

If you want to integrate this with Google, Claude, or Youtube, you would need to get the API keys at this point before running the configuration
For Google and Youtube you would need to go to [Google Cloud](https://console.cloud.google.com/) and create an account if you dont already have one


Create a Project in Google Cloud
![Google Cloud Project](https://github.com/ebelious/Self-Hosted/blob/main/Images/Screenshot%20from%202024-07-12%2016-31-29.png)
 
 
 On the project dashboard, click Explore & Enable APIs and select `API Library` and then search for `YouTube Data API v3`.
![Credentials-api](https://github.com/user-attachments/assets/749172c5-57ee-404a-8326-3ced35607f8b)


Enable this API and and create the credentials
![Enable API](https://github.com/ebelious/Self-Hosted/blob/main/Images/Screenshot%20from%202024-07-12%2016-43-27.png)
![Credentials API](https://github.com/ebelious/Self-Hosted/blob/main/Images/Screenshot%20from%202024-07-12%2016-45-11.png)


Once you get to thes page select next with the fololwing options selected 
![nex1](https://github.com/ebelious/Self-Hosted/blob/main/Images/Screenshot%20from%202024-07-12%2016-47-23.png)

You can now get the API to input into the fabric configuration
```
fabric --setup
```
## Using fabric

See the list of models currently on the system
```
fabric --listmodels
```

Specify the Default Model

```
fabric --changeDefaultModel llama3:latest
```

#### Example 1:

Get Youtube Transcript by right-clicking CC on the video and selecting `Copy video URL`
![right-click](https://github.com/ebelious/Self-Hosted/blob/main/Images/Screenshot%20from%202024-07-12%2016-59-11.png)

```
yt --transcript https://youtu.be/UbDyjIIGaxQ | fabric -sp extract_wisdom
```

#### Example 2:

Replicate pbpaste and pbcopy commands in lnux by modifying .bashrc or .zshrc files
Create aliases

```
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'
```

```
# Simulate OSX's pbcopy and pbpaste on other platforms
if [ ! $(uname -s) = "Darwin" ]; then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
fi
```

```
pbpaste | fabric -p summarize | fabric -sp write_essay
```
