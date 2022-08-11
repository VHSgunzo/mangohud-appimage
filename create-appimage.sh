#!/usr/bin/env bash

(cd / && ./linuxdeploy.AppImage --appimage-extract)
cd /git

cat << EOF > ./mangohud.desktop
[Desktop Entry]
Encoding=UTF-8
Name=MangoHud
Categories=Game;
Exec=mangohud %U
Icon=debian-logo
Terminal=true
Type=Application
StartupNotify=true
EOF

cat <<'EOF' > ./AppDir/MangoHud.conf
no_display
gpu_stats
gpu_temp
gpu_core_clock
gpu_mem_clock
gpu_power
gpu_load_change
gpu_load_value=50,90
gpu_load_color=FFFFFF,FF7800,CC0000
gpu_text=GPU
cpu_stats
cpu_temp
cpu_load_change
core_load_change
cpu_load_value=50,90
cpu_load_color=FFFFFF,FF7800,CC0000
cpu_color=2e97cb
cpu_text=CPU
io_color=a491d3
vram
vram_color=ad64c1
ram
ram_color=c26693
fps
engine_version
engine_color=eb5b5b
gpu_name
gpu_color=2e9762
vulkan_driver
wine
wine_color=eb5b5b
arch
frame_timing=1
frametime_color=00ff00
show_fps_limit
resolution
vkbasalt
gamemode
background_alpha=0.4
font_size=24
background_color=020202
position=top-left
text_color=ffffff
toggle_hud=Shift_R+F12
toggle_fps_limit=Shift_L+F1
fps_limit=75+0
EOF

cat <<'EOF' > ./AppDir/AppRun
#!/bin/bash

HERE="$(dirname "$(readlink -f "${0}")")"

if [ "$#" -eq 0 ]; then
        echo "ERROR: No program supplied"
        echo
        echo "Usage: mangohud <program>"
        exit 1
fi

if [ "$1" = "--dlsym" ]; then
        export MANGOHUD_DLSYM=1
        shift
fi

MANGOHUD_LIB_NAME="libMangoHud.so"

if [ "$MANGOHUD_DLSYM" = "1" ]; then
        MANGOHUD_LIB_NAME="libMangoHud_dlsym.so:${MANGOHUD_LIB_NAME}"
fi

export MANGOHUD=1
[[ ! -n "$MANGOHUD_CONFIGFILE" && ! -n "$MANGOHUD_CONFIG" && "$MANGOHUD_USER_CONF" != 1 ]] && \
export MANGOHUD_CONFIGFILE="$HERE/MangoHud.conf"
export LD_PRELOAD="${LD_PRELOAD}:${MANGOHUD_LIB_NAME}"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:$HERE/usr/lib/mangohud/\$LIB/"
export VK_LAYER_PATH="${VK_LAYER_PATH}:$HERE/usr/share/vulkan/implicit_layer.d/"
export VK_INSTANCE_LAYERS=${VK_INSTANCE_LAYERS}:VK_LAYER_MANGOHUD_overlay

"$@"
EOF

chmod +x ./AppDir/AppRun
(cd ./AppDir/usr/
ln -sv lib64 ././lib/mangohud/lib
ln -sv lib64 ././lib/mangohud/x86_64
ln -sv lib64 ././lib/mangohud/x86_64-linux-gnu
ln -sv lib32 ././lib/mangohud/i686
ln -sv lib32 ././lib/mangohud/i386-linux-gnu
ln -sv ../lib32 ././lib/mangohud/lib/i386-linux-gnu
ln -sv lib32 ././lib/mangohud/i686-linux-gnu
ln -sv ../lib32 ././lib/mangohud/lib/i686-linux-gnu
sed -i 's#/usr/#../../../#g' ./share/vulkan/implicit_layer.d/MangoHud.json)

export ARCH=x86_64
/squashfs-root/AppRun \
  --appdir ./AppDir \
  -d ./mangohud.desktop \
  -i /usr/share/pixmaps/debian-logo.png \
  --output appimage

MANGOHUD_VERSION="$(cat 'mangohud_version' 2>/dev/null)"
MANGOHUD_AI="$(ls ./*.AppImage 2>/dev/null)"

[ -f "$MANGOHUD_AI" ] && \
mv "$MANGOHUD_AI" /target/MangoHud-${MANGOHUD_VERSION}-${ARCH}.AppImage
# [ -f "$MANGOHUD_AI" ] && \
# mv "$MANGOHUD_AI" /target/mangohud

exec "$@"
