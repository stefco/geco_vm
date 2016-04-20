# settings that probably need to be run by the user

# make sure enough time has passed since startup for the desktop to start
sleep 30

# disable automatic screen lock
gsettings set org.gnome.desktop.screensaver lock-enabled false

# set the favorites on the desktop
gsettings set com.canonical.Unity.Launcher favorites "['nautilus-home.desktop', '/home/vagrant/.medm_launcher/medm-lho.desktop', '/home/vagrant/.medm_launcher/medm-llo.desktop', 'gnome-terminal.desktop', 'firefox.desktop', 'libreoffice-writer.desktop', 'libreoffice-calc.desktop', 'libreoffice-impress.desktop']"
