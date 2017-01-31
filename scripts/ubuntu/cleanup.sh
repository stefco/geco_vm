#!/bin/sh -eux

cat <<__MSG__
***********************************************************
*
*
* DELETE ALL LINUX HEADERS
*
*
***********************************************************
__MSG__
dpkg --list \
  | awk '{ print $2 }' \
  | grep 'linux-headers' \
  | xargs apt-get -y purge;

cat <<__MSG__
***********************************************************
*
*
* REMOVE SPECIFIC LINUX KERNELS
*
*
***********************************************************
__MSG__
# Remove specific Linux kernels, such as linux-image-3.11.0-15-generic but
# keeps the current kernel and does not touch the virtual packages,
# e.g. 'linux-image-generic', etc.
dpkg --list \
    | awk '{ print $2 }' \
    | grep 'linux-image-3.*-generic' \
    | grep -v `uname -r` \
    | xargs apt-get -y purge;

cat <<__MSG__
***********************************************************
*
*
* DELETE LINUX SOURCE
*
*
***********************************************************
__MSG__
# Delete Linux source
dpkg --list \
    | awk '{ print $2 }' \
    | grep linux-source \
    | xargs apt-get -y purge;

cat <<__MSG__
***********************************************************
*
*
* DELETE DEVELOPMENT PACKAGES
*
*
***********************************************************
__MSG__
# Delete development packages
# do not remove julia dev packages; they are required
# do not remove ubuntu packages
dpkg --list \
    | awk '{ print $2 }' \
    | grep -- '-dev$' \
    | sed '/ubuntu/d'
    | sed '/julia/d' \
    | xargs apt-get -y purge;

# cat <<__MSG__
# ***********************************************************
# *
# *
# * DELETE X11 LIBRARIES
# *
# *
# ***********************************************************
# __MSG__
# # Delete X11 libraries
# apt-get -y purge libx11-data xauth libxmuu1 libxcb1 libx11-6 libxext6;

cat <<__MSG__
***********************************************************
*
*
* DELETE OBSOLETE NETWORKING
*
*
***********************************************************
__MSG__
# Delete obsolete networking
apt-get -y purge ppp pppconfig pppoeconf;

cat <<__MSG__
***********************************************************
*
*
* DELETE ODDITIES
*
*
***********************************************************
__MSG__
# Delete oddities
apt-get -y purge popularity-contest;

cat <<__MSG__
***********************************************************
*
*
* AUTOREMOVE PACKAGES
*
*
***********************************************************
__MSG__
apt-get -y autoremove;

cat <<__MSG__
***********************************************************
*
*
* CLEAN
*
*
***********************************************************
__MSG__
apt-get -y clean;

cat <<__MSG__
***********************************************************
*
*
* DELETE GUEST ADDITIONS ISO
*
*
***********************************************************
__MSG__
rm -f VBoxGuestAdditions_*.iso VBoxGuestAdditions_*.iso.?;
