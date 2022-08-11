# MangoHud-AppImage
* Build MangoHud AppImage in docker

## To get started:

* **Install git and docker for your distribution**

* **Download the latest revision**
```
git clone https://github.com/VHSgunzo/mangohud-appimage.git && cd mangohud-appimage
```

* **Build docker image**
```
docker build ./ -t mangohud
```

* **Build MangoHud AppImage**
```
# Replace <BUILD_DIRECTORY> by the full path where you want to find the result of the build
docker run --rm -v <BUILD_DIRECTORY>:/target mangohud:latest
```

## Usage:
```
MangoHud.*-x86_64.AppImage <program>
```

## Default parameters:
```
config file: /tmp/.mount_.*/MangoHud.conf (in MangoHud AppImage)
toggle_hud = Shift_R+F12
toggle_fps_limit = Shift_L+F1
fps_limit = 75+0
```

## Additional environment variables:
```
MANGOHUD_CONFIG=<no_display,gpu_stats,gpu_temp...>
MANGOHUD_USER_CONF=<1 or 0 for use custom user configs>
MANGOHUD_CONFIGFILE=<custom MangoHud config file>
```
