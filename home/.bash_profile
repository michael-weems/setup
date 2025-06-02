# directly launch hyprland on systemd boot
if uwsm check may-start; then
    exec uwsm start hyprland.desktop
fi
