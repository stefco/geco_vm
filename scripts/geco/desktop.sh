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

# install gimp
apt-get -y -qq install gimp
