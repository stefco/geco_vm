date > /etc/vagrant_box_build_time

mkdir /home/vagrant/.ssh
wget --no-check-certificate \
    'https://github.com/mitchellh/vagrant/raw/master/keys/vagrant.pub' \
    -O /home/vagrant/.ssh/authorized_keys
chown 700 /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/authorized_keys
ls -l /home/vagrant/.ssh
ls -l /home/vagrant/.ssh/authorized_keys
cat /home/vagrant/.ssh/authorized_keys/*
