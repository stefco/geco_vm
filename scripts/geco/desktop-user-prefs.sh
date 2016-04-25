# desktop settings

# make sure enough time has passed since startup for the desktop to start
sleep 10

# disable automatic screen lock
dbus-launch --exit-with-session gsettings set org.gnome.desktop.screensaver lock-enabled false

# set the favorites on the desktop
dbus-launch --exit-with-session gsettings set com.canonical.Unity.Launcher favorites "['/home/vagrant/.medm_launcher/auth.desktop', 'nautilus-home.desktop', '/home/vagrant/.medm_launcher/browse-data-grid.desktop', '/home/vagrant/.medm_launcher/update-and-ssh-data-grid.desktop', '/home/vagrant/.medm_launcher/geco-soft.desktop', '/home/vagrant/.medm_launcher/medm-lho.desktop', '/home/vagrant/.medm_launcher/medm-llo.desktop', 'gnome-terminal.desktop', 'firefox.desktop']"

# set default terminal font to Deja Vu Sans, 9 point font
dbus-launch --exit-with-session gconftool-2 --set /apps/gnome-terminal/profiles/Default/use_system_font --type=boolean false
dbus-launch --exit-with-session gconftool-2 --set /apps/gnome-terminal/profiles/Default/font --type string "Deja Vu Sans Mono 9"
