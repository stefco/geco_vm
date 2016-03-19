# By Stefan with much help from Szabi and Petr.

# prevent grub from launching gui on upgrade
# from: https://github.com/mitchellh/vagrant/issues/289
# also: http://feeding.cloud.geek.nz/posts/manipulating-debconf-settings-on/
echo "set grub-pc/install_devices /dev/sda" | debconf-communicate

# move build-with-autotools file around as needed.
if [ -e /vagrant/build-with-autotools.sh ]; then
    echo build-with-autotools.sh found in vagrant directory.
    cp /vagrant/build-with-autotools.sh /home/vagrant/build-with-autotools.sh
elif [ -e /tmp/build-with-autotools.sh ]; then
    echo build-with-autotools.sh found in packer directory.
    cp /tmp/build-with-autotools.sh /home/vagrant/build-with-autotools.sh
else
    echo build-with-autotools.sh not found.
    exit 1
fi

# environmental variables
export DEBIAN_FRONTEND=noninteractive
export SWIG_VERSION="3.0.8"
export FFTW_VERSION="3.3.4"
export LAL_VERSION="6.15.0"
export LALFRAME_VERSION="1.3.0"
export LIBFRAME_VERSION="8.20"
export LDAS_TOOLS_VERSION="2.4.1"
export NDS2_CLIENT_VERSION="0.10.4"
export SWIG_="https://github.com/swig/swig/archive/rel-${SWIG_VERSION}.tar.gz"
export FFTW="http://www.fftw.org/fftw-${FFTW_VERSION}.tar.gz"
export LDAS_TOOLS="http://software.ligo.org/lscsoft/source/ldas-tools-${LDAS_TOOLS_VERSION}.tar.gz"
export LIBFRAME="http://software.ligo.org/lscsoft/source/libframe-${LIBFRAME_VERSION}.tar.gz"
export LAL="http://software.ligo.org/lscsoft/source/lalsuite/lal-${LAL_VERSION}.tar.gz"
export LALFRAME="http://software.ligo.org/lscsoft/source/lalsuite/lalframe-${LALFRAME_VERSION}.tar.gz"
export NDS2_CLIENT="http://software.ligo.org/lscsoft/source/nds2-client-${NDS2_CLIENT_VERSION}.tar.gz"

cat <<__MSG__
***********************************************************
*
*
* UPDATING 
*
*
***********************************************************
__MSG__
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

cat <<__MSG__
***********************************************************
*
*
* INSTALLING REQUIREMENTS 
*
*
***********************************************************
__MSG__
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
# install pip
# lal dependencies
apt-get -y -qq install pkg-config
apt-get -y -qq install python-all-dev
apt-get -y -qq install zlib1g-dev
apt-get -y -qq install libgsl0-dev
apt-get -y -qq install swig
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

cat <<__MSG__
***********************************************************
*
*
* INSTALLING GLOBUS 
*
*
***********************************************************
__MSG__
wget http://www.globus.org/ftppub/gt6/installers/repo/globus-toolkit-repo_latest_all.deb
dpkg -i globus-toolkit-repo_latest_all.deb
apt-get -y -qq update
apt-get -y -qq -o Dpkg::Options::="--force-confdef" -o \
                  Dpkg::Options::="--force-confold" install \
                  globus-gridftp globus-gram5 globus-gsi \
                  globus-data-management-server globus-data-management-client \
                  globus-resource-management-client
# rm globus-toolkit-repo_latest_all.deb*

cat <<__MSG__
***********************************************************
*
*
* INSTALLING DATAGRID
*
*
***********************************************************
__MSG__
wget -O- http://www.lsc-group.phys.uwm.edu/lscdatagrid/doc/ldg-client.sh | bash 
ldg-version
apt-get -y -qq update
apt-get -y -qq dist-upgrade

cat <<__MSG__
***********************************************************
*
*
* INSTALLING LIGO TOOLS FROM SOURCE
*
*
***********************************************************
__MSG__
# install lscsoft
echo 'deb http://software.ligo.org/lscsoft/debian wheezy contrib' > /etc/apt/sources.list.d/lscsoft.list
echo 'deb-src http://software.ligo.org/lscsoft/debian wheezy contrib' > /etc/apt/sources.list.d/lscsoft-src.list
# quietly installing untrusted packages: https://anothersysadmin.wordpress.com/2008/12/30/tip-installing-untrusted-packages-without-confirmation-on-debian/
# aptitude --no-gui -y -q update || true
# aptitude --no-gui -o Aptitude::Cmdline::ignore-trust-violations=true -y -q full-upgrade || true
# aptitude --no-gui -o Aptitude::Cmdline::ignore-trust-violations=true -y -q install lscsoft-archive-keyring || true
# aptitude --no-gui -o Aptitude::Cmdline::ignore-trust-violations=true -y -q install lscsoft-all || true
# aptitude --no-gui -o Aptitude::Cmdline::ignore-trust-violations=true -y -q install nds2-client || true
# aptitude --no-gui -o Aptitude::Cmdline::ignore-trust-violations=true -y -q install lalapps || true

# THE BELOW SCRIPTS BUILD FROM SOURCE
# set paths for PKG_CONFIG <-- THIS IS PROBABLY UNNECESSARY OFF OF TRAVIS
# export PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:${VIRTUAL_ENV}/lib/pkgconfig
# build a newer version of swig
bash /home/vagrant/build-with-autotools.sh swig-${SWIG_VERSION} ${SWIG_}
# build FFTW3 (double and float)
bash /home/vagrant/build-with-autotools.sh fftw-${FFTW_VERSION} ${FFTW} --enable-shared=yes
bash /home/vagrant/build-with-autotools.sh fftw-${FFTW_VERSION}-float ${FFTW} --enable-shared=yes --enable-float
# build frame libraries
bash /home/vagrant/build-with-autotools.sh ldas-tools-${LDAS_TOOLS_VERSION} ${LDAS_TOOLS}
bash /home/vagrant/build-with-autotools.sh libframe-${LIBFRAME_VERSION} ${LIBFRAME}
# build LAL packages
bash /home/vagrant/build-with-autotools.sh lal-${LAL_VERSION} ${LAL} --enable-swig-python
bash /home/vagrant/build-with-autotools.sh lalframe-${LALFRAME_VERSION} ${LALFRAME} --enable-swig-python
# build NDS2 client
bash /home/vagrant/build-with-autotools.sh nds2-client-${NDS2_CLIENT_VERSION} ${NDS2_CLIENT} --disable-swig-java --disable-mex-matlab
# # install cython to speed up scipy build
# pip install -q --install-option="--no-cython-compile" Cython
# # install testing dependencies
# pip install -q coveralls "pytest>=2.8" unittest2

cat <<__MSG__
***********************************************************
*
*
* INSTALLING PYTHON UTILITIES
*
*
***********************************************************
__MSG__
# update pip
pip install -q --upgrade pip
# add security stuff for gwpy to prevent InsecurePlatformWarning
# see: http://stackoverflow.com/questions/29134512/insecureplatformwarning-a-true-sslcontext-object-is-not-available-this-prevent
/usr/local/bin/pip install -q requests[security]
# build and install numpy first
/usr/local/bin/pip install -q "numpy>=1.9.1"
# install ipython and jupyter
# /usr/local/bin/pip install -q ipython
# but do it using apt-get instead
apt-get install -y -qq ipython
/usr/local/bin/pip install -q jupyter

cat <<__MSG__
***********************************************************
*
*
* INSTALLING GWPY
*
*
***********************************************************
__MSG__
/usr/local/bin/pip install gwpy

cat <<__MSG__
***********************************************************
*
*
* INSTALLING EXTRAS
*
*
***********************************************************
__MSG__
apt-get -y -qq install curl
apt-get -y -qq install wget
apt-get -y -qq install vim
apt-get -y -qq install ncdu

cat <<__MSG__
***********************************************************
*
*
* INSTALLING JULIA
*
*
************************************************************
__MSG__
# need add-apt-repository, install with the below command.
# see: http://lifeonubuntu.com/ubuntu-missing-add-apt-repository-command/
apt-get -y -qq install software-properties-common python-software-properties
add-apt-repository -y ppa:staticfloat/juliareleases
add-apt-repository -y ppa:staticfloat/julia-deps
apt-get -y -qq update || true
apt-get -y -qq install julia || true
# Install iJulia
julia --eval 'Pkg.add("IJulia")'
# since installed w/ sudo, must change permissions back to the default user.
chown -R vagrant /home/vagrant

cat <<__MSG__
************************************************************
*
*
* DONE PROVISIONING!
*
*
************************************************************
__MSG__
