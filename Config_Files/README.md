# dot and config files oh my!
## Fastfetch
`fastfetch` <br />
`fastfetch -l none` (No Logo)
![fastfetch](https://github.com/ebelious/Self-Hosted/blob/main/Images/Screenshot%20from%202024-07-15%2017-14-44.png)

```
sudo apt install fastfetch
```
```
sudo dnf install fastfetch
```
[Fastfetch JSON Schema](https://github.com/fastfetch-cli/fastfetch/wiki/Json-Schema)

## Conky

![conky](https://github.com/ebelious/Self-Hosted/blob/main/Images/Screenshot%20from%202024-07-15%2017-49-08.png)


**Prereqs:**
- Conky: `sudo apt install conky`, `sudo dnf install conky`
- Sensors: `sudo apt install lm_sensors`, `sudo dnf install lm_sensors`
- Icons: `https://www.deviantart.com/stash/01rs0v64gfd7`. Put these in a font folder such as `~/.local/share/fonts/`

## Bash Prompt 
This will print the time in the right column of the terminal<br />
This also has the directory above the comman line (shorthand for home directory) [Bash](https://github.com/ebelious/Self-Hosted/blob/main/Bash.md)<br />

```
## Time on right column prompt
rightprompt()
{
    printf "%*s" $COLUMNS "[$(date +%r)]"
}
PS1='\[$(tput sc; rightprompt; tput rc)\]\w\n\e[1;32m[\e[0m\e[1;36m>\e[0m\e[1;32m]\e[0m '
```

![Prompt](https://github.com/ebelious/Self-Hosted/blob/main/Images/Screenshot%20from%202024-07-17%2010-40-18.png)

## Gnome Terminal Themes
<p align="center">
<img width="500" height="200" src="https://raw.githubusercontent.com/Gogh-Co/Gogh/master/images/gogh/Gogh-logo-dark.png">
</p>

##### [Gogh](https://gogh-co.github.io/Gogh/)
You can pull a single theme or all of the themes if you are insane
```
bash -c  "$(wget -qO- https://git.io/vQgMr)" 
```
#### lsd - nextgen LS
[github](https://github.com/lsd-rs/lsd)
```
sudo apt install lsd
```
```
sudo dnf install lsd
```

![lsd](https://github.com/ebelious/Self-Hosted/blob/main/Images/Screenshot%20from%202024-07-17%2016-08-13.png)
