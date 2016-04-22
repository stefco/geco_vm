# settings that probably need to be run by the user

# make sure enough time has passed since startup for the desktop to start
sleep 10

# disable automatic screen lock
dbus-launch --exit-with-session gsettings set org.gnome.desktop.screensaver lock-enabled false

# set the favorites on the desktop
dbus-launch --exit-with-session gsettings set com.canonical.Unity.Launcher favorites "['nautilus-home.desktop', '/home/vagrant/.medm_launcher/auth.desktop', '/home/vagrant/.medm_launcher/medm-lho.desktop', '/home/vagrant/.medm_launcher/medm-llo.desktop', 'gnome-terminal.desktop', 'firefox.desktop']"
