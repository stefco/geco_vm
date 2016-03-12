# By Stefan with much help from Szabi and Petr.

# prevent grub from launching gui on upgrade
# from: https://github.com/mitchellh/vagrant/issues/289
# also: http://feeding.cloud.geek.nz/posts/manipulating-debconf-settings-on/
echo "set grub-pc/install_devices /dev/sda" | debconf-communicate

# environmental variables
export DEBIAN_FRONTEND=noninteractive
SWIG_VERSION="3.0.8"
FFTW_VERSION="3.3.4"
LAL_VERSION="6.15.0"
LALFRAME_VERSION="1.3.0"
LIBFRAME_VERSION="8.20"
LDAS_TOOLS_VERSION="2.4.1"
NDS2_CLIENT_VERSION="0.10.4"
SWIG_="https://github.com/swig/swig/archive/rel-${SWIG_VERSION}.tar.gz"
FFTW="http://www.fftw.org/fftw-${FFTW_VERSION}.tar.gz"
LDAS_TOOLS="http://software.ligo.org/lscsoft/source/ldas-tools-${LDAS_TOOLS_VERSION}.tar.gz"
LIBFRAME="http://software.ligo.org/lscsoft/source/libframe-${LIBFRAME_VERSION}.tar.gz"
LAL="http://software.ligo.org/lscsoft/source/lalsuite/lal-${LAL_VERSION}.tar.gz"
LALFRAME="http://software.ligo.org/lscsoft/source/lalsuite/lalframe-${LALFRAME_VERSION}.tar.gz"
NDS2_CLIENT="http://software.ligo.org/lscsoft/source/nds2-client-${NDS2_CLIENT_VERSION}.tar.gz"

printf '************************************************************************\n'
printf '*\n*\n* UPDATING \n*\n*\n'
printf '************************************************************************\n'
# necessary on this version of ubuntu due to hash sum difficulties.
# see: https://github.com/mininet/mininet/issues/438
# this works, but the following might come in handy
# see: http://askubuntu.com/questions/311842/how-do-i-fix-apt-errors-w-failed-to-fetch-hash-sum-mismatch
rm -rf /var/lib/apt/lists/*
apt-get -y -qq update
sync
# shutdown -h now
# update
apt-get -y -qq update
apt-get -y -qq -o Dpkg::Options::="--force-confdef" -o \
                  Dpkg::Options::="--force-confold" dist-upgrade
apt-get -y install linux-headers-$(uname -r)

# passwordless sudo (necessary for vagrant, you can turn it off yourself later)
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers
sed -i -e 's/%sudo  ALL=(ALL:ALL) ALL/%sudo  ALL=NOPASSWD:ALL/g' /etc/sudoers
echo "UseDNS no" >> /etc/ssh/sshd_config

printf '************************************************************************\n'
printf '*\n*\n* INSTALLING REQUIREMENTS \n*\n*\n'
printf '************************************************************************\n'
# prevent postfix from launching gui on install
# via: http://serverfault.com/questions/143968/automate-the-installation-of-postfix-on-ubuntu?newreg=537d60dfb3294436bde1409e74336fe1
# debconf-set-selections <<< "postfix postfix/mailname string your.hostname.com"
# debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
apt-get -y -qq install postfix
# generic packages
apt-get -y -qq install gcc
apt-get -y -qq install gfortran
apt-get -y -qq install python-dev
apt-get -y -qq install libblas-dev
apt-get -y -qq install liblapack-dev
# need make and other essentials
apt-get -y -qq install build-essential
# need automake for autotools to work
apt-get -y -qq install automake
# also need PCRE developer package
apt-get -y -qq install libpcre3 libpcre3-dev
# ALSO need bison for the command yacc
apt-get -y -qq install bison
# need this for python requests
apt-get -y -qq install libffi-dev
# some matplotlib dependencies
apt-get -y -qq install libfreetype6-dev
apt-get -y -qq install libpng-dev libjpeg8-dev
# lal dependencies
apt-get -y -qq install pkg-config
apt-get -y -qq install python-all-dev
apt-get -y -qq install zlib1g-dev
apt-get -y -qq install libgsl0-dev
apt-get -y -qq install swig
apt-get -y -qq install python-pip
apt-get -y -qq install python-numpy
apt-get -y -qq install python-scipy
apt-get -y -qq install bc
# nds2 dependencies
apt-get -y -qq install libsasl2-2
# glue dependencies
apt-get -y -qq install python-m2crypto
# misc python dependencies
apt-get -y -qq install texlive-latex-extra
apt-get -y -qq install libhdf5-serial-dev

printf '************************************************************************\n'
printf '*\n*\n* INSTALLING GLOBUS \n*\n*\n'
printf '************************************************************************\n'
wget http://www.globus.org/ftppub/gt6/installers/repo/globus-toolkit-repo_latest_all.deb
dpkg -i globus-toolkit-repo_latest_all.deb
apt-get -y -qq update
apt-get -y -qq -o Dpkg::Options::="--force-confdef" -o \
                  Dpkg::Options::="--force-confold" install \
                  globus-gridftp globus-gram5 globus-gsi \
                  globus-data-management-server globus-data-management-client \
                  globus-resource-management-client
# rm globus-toolkit-repo_latest_all.deb*

printf '************************************************************************\n'
printf '*\n*\n* INSTALLING DATAGRID \n*\n*\n'
printf '************************************************************************\n'
wget -O- http://www.lsc-group.phys.uwm.edu/lscdatagrid/doc/ldg-client.sh | bash 
ldg-version
apt-get -y -qq update
apt-get -y -qq dist-upgrade

printf '************************************************************************\n'
printf '*\n*\n* INSTALLING PYTHON UTILITIES \n*\n*\n'
printf '************************************************************************\n'

printf '\n\n ENDING NOW, RESUME WITH VAGRANT TO DEBUG PIP\n\n'
