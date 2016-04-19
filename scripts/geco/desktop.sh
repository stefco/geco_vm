# install the unity desktop environment
apt-get -y -qq install ubuntu-desktop

# automatically log the default user in on startup
sudo cat <<LIGHTDM_CONF > /etc/lightdm/lightdm.conf
[SeatDefaults]
greeter-session=unity-greeter
user-session=ubuntu
autologin-user=vagrant
autologin-user-timeout=0
LIGHTDM_CONF

su - vagrant -c 'gsettings set com.canonical.Unity.Launcher favorites "['"'"'nautilus-home.desktop'"'"', '"'"'gnome-terminal.desktop'"'"', '"'"'firefox.desktop'"'"', '"'"'libreoffice-writer.desktop'"'"', '"'"'libreoffice-calc.desktop'"'"', '"'"'libreoffice-impress.desktop'"'"', '"'"'ubuntu-software-center.desktop'"'"', '"'"'gnome-control-center.desktop'"'"']"'
su - vagrant -c 'gsettings set org.gnome.desktop.screensaver lock-enabled false'
