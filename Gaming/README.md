

## Gnome specific gaming mods and fixes


### Clicking off screen minimizes game (How to stop this)
Add this to the `/etc/enviroment` file
```
SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS=0
```

### How to increase volume limit over 100%
Enter via cli
```
gsettings set org.gnome.desktop.sound allow-volume-above-100-percent 'true'
```
