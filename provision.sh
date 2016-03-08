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
apt-get -y -qq -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade

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
printf '*\n*\n* INSTALLING UTILITIES \n*\n*\n'
printf '************************************************************************\n'
# update pip
pip install -q --upgrade pip
# build and install numpy first
pip install -q "numpy>=1.9.1"
# install ipython and jupyter
pip install -q ipython
pip install -q jupyter
# install lscsoft
echo 'deb http://software.ligo.org/lscsoft/debian wheezy contrib' > /etc/apt/sources.list.d/lscsoft.list
echo 'deb-src http://software.ligo.org/lscsoft/debian wheezy contrib' > /etc/apt/sources.list.d/lscsoft-src.list
# quietly installing untrusted packages: https://anothersysadmin.wordpress.com/2008/12/30/tip-installing-untrusted-packages-without-confirmation-on-debian/
aptitude --no-gui -y -q update
aptitude --no-gui -o Aptitude::Cmdline::ignore-trust-violations=true -y -q full-upgrade
aptitude --no-gui -o Aptitude::Cmdline::ignore-trust-violations=true -y -q install lscsoft-archive-keyring
aptitude --no-gui -o Aptitude::Cmdline::ignore-trust-violations=true -y -q install lscsoft-all
aptitude --no-gui -o Aptitude::Cmdline::ignore-trust-violations=true -y -q install nds2-client
aptitude --no-gui -o Aptitude::Cmdline::ignore-trust-violations=true -y -q install lalapps

# THE BELOW SCRIPTS ALLOW BUILDING FROM SOURCE
# # set paths for PKG_CONFIG <-- THIS IS PROBABLY UNNECESSARY OFF OF TRAVIS
# export PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:${VIRTUAL_ENV}/lib/pkgconfig
# build a newer version of swig
# source /vagrant/provisioning/build-with-autotools.sh swig-${SWIG_VERSION} ${SWIG_}
# build FFTW3 (double and float)
# source /vagrant/provisioning/build-with-autotools.sh fftw-${FFTW_VERSION} ${FFTW} --enable-shared=yes
# source /vagrant/provisioning/build-with-autotools.sh fftw-${FFTW_VERSION}-float ${FFTW} --enable-shared=yes --enable-float
# # build frame libraries
# source /vagrant/provisioning/build-with-autotools.sh ldas-tools-${LDAS_TOOLS_VERSION} ${LDAS_TOOLS}
# source /vagrant/provisioning/build-with-autotools.sh libframe-${LIBFRAME_VERSION} ${LIBFRAME}
# # build LAL packages
# source /vagrant/provisioning/build-with-autotools.sh lal-${LAL_VERSION} ${LAL} --enable-swig-python
# source /vagrant/provisioning/build-with-autotools.sh lalframe-${LALFRAME_VERSION} ${LALFRAME} --enable-swig-python
# # build NDS2 client
# source /vagrant/provisioning/build-with-autotools.sh nds2-client-${NDS2_CLIENT_VERSION} ${NDS2_CLIENT} --disable-swig-java --disable-mex-matlab
# # install cython to speed up scipy build
# travis_retry pip install -q --install-option="--no-cython-compile" Cython
# # install testing dependencies
# pip install -q coveralls "pytest>=2.8" unittest2

printf '************************************************************************\n'
printf '*\n*\n* INSTALLING EXTRAS \n*\n*\n'
printf '************************************************************************\n'
apt-get -y -qq install curl
apt-get -y -qq install wget
apt-get -y -qq install vim

printf '************************************************************************\n'
printf '*\n*\n* INSTALLING JULIA \n*\n*\n'
printf '************************************************************************\n'
# need add-apt-repository: http://lifeonubuntu.com/ubuntu-missing-add-apt-repository-command/
apt-get -y -qq install software-properties-common python-software-properties
add-apt-repository -y ppa:staticfloat/juliareleases
add-apt-repository -y ppa:staticfloat/julia-deps
apt-get -y -qq update
apt-get -y -qq install julia
julia --eval 'Pkg.add("IJulia")'
