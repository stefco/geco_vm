#!/bin/bash

# stefan.countryman@LIGO.ORG 3/29/16

# create a dpkg config file that tells apt not to install documentation. taken
# from https://wiki.ubuntu.com/ReducingDiskFootprint#Documentation
# with modification to still include man files

mkdir -pv /etc/dpkg/dpkg.cfg.d

cat <<__EOF__ > /etc/dpkg/dpkg.cfg.d/01_nodoc
path-exclude /usr/share/doc/*
# we need to keep copyright files for legal reasons
path-include /usr/share/doc/*/copyright
# path-exclude /usr/share/groff/*
# path-exclude /usr/share/info/*
# lintian stuff is small, but really unnecessary
path-exclude /usr/share/lintian/*
path-exclude /usr/share/linda/*
__EOF__

# remove any existing documentation

find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true
find /usr/share/doc -empty|xargs rmdir || true
# rm -rf /usr/share/groff/* /usr/share/info/*
rm -rf /usr/share/lintian/* /usr/share/linda/*
