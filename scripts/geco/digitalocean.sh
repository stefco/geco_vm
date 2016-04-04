echo Adding user account vagrant...
# add user 'vagrant'
# the below should output paX5EmO4EXy0I
password='vagrant'
encrypted_password="$(perl -e 'printf("%s\n", crypt($ARGV[0], "password"))' "$password")"
# the password is just "vagrant" encrypted
useradd -m -p paX5EmO4EXy0I -s /bin/bash vagrant

echo Adding 2 GiB of swap...
# add 2gb swap for large installs
echo Adding 2 GiB of swap...
dd if=/dev/zero of=/mnt/2GiB.swap bs=4096 count=2097152
chmod 600 /mnt/2GiB.swap
mkswap /mnt/2GiB.swap
swapon /mnt/2GiB.swap
echo '/mnt/2GiB.swap  none  swap  sw  0 0' >> /etc/fstab
echo Swap should now be available. running free:
free
