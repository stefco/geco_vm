cat <<__MSG__
***********************************************************
*
*
* INSTALLING REMOTE MEDM VIEWER
*
*
***********************************************************
__MSG__
# Install instructions from source:
# https://lhocds.ligo-wa.caltech.edu/wiki/SysAdmin/MacOSX/InstallEPICS
# Dependencies
apt-get install -y -qq libreadline6 libreadline6-dev
apt-get install -y -qq libmotif-dev
# Recommended install location for epics
mkdir -pv /opt/epics
# Recommended tarball archive area
mkdir -pv /opt/epics/distfiles
# EPICS base; find it here: http://www.aps.anl.gov/epics/download/index.php
export EPICS_BASE_VERSION="3.14.12.4"
export TOP_VERSION="20120904"
export MEDM_VERSION="3_1_9"
export ALARM_HANDLER_VERSION="1_2_34"
export PROBE_VERSION="1_1_8_0"
wget --directory-prefix=/opt/epics/distfiles \
    http://www.aps.anl.gov/epics/download/base/baseR$EPICS_BASE_VERSION.tar.gz
wget --directory-prefix=/opt/epics/distfiles \
    http://www.aps.anl.gov/epics/download/extensions/extensionsTop_$TOP_VERSION.tar.gz
wget --directory-prefix=/opt/epics/distfiles \
    http://www.aps.anl.gov/epics/download/extensions/medm$MEDM_VERSION.tar.gz
wget --directory-prefix=/opt/epics/distfiles \
    http://www.aps.anl.gov/epics/download/extensions/alh$ALARM_HANDLER_VERSION.tar.gz
wget --directory-prefix=/opt/epics/distfiles \
    http://www.aps.anl.gov/epics/download/extensions/probe$PROBE_VERSION.tar.gz
# Extract the source trees
cd /opt/epics
tar -zxvopf distfiles/baseR$EPICS_BASE_VERSION.tar.gz
tar -zxvopf distfiles/extensionsTop_$TOP_VERSION.tar.gz
ln -s base-$EPICS_BASE_VERSION base
cd /opt/epics/extensions/src
tar -zxvopf ../../distfiles/medm$MEDM_VERSION.tar.gz
tar -zxvopf ../../distfiles/alh$ALARM_HANDLER_VERSION.tar.gz
tar -zxvopf ../../distfiles/probe$PROBE_VERSION.tar.gz
# Apply patches
wget --output-document=/opt/epics/distfiles/epics-patches-mac-10.9.tar.gz \
    https://www.dropbox.com/s/v12hd5knzpgv8r2/epics-patches-mac-10.9.tar.gz?dl=1
    # this is password protected, but is the original source:
    # https://lhocds.ligo-wa.caltech.edu/wiki/SysAdmin/MacOSX/InstallEPICS?action=AttachFile&do=get&target=epics-patches-mac-10.9.tar.gz
cd /opt/epics/distfiles
tar -zxvopf epics-patches-mac-10.9.tar.gz
cd /opt/epics/base
patch -p0 < ../distfiles/epics-patches-mac-10.9/epics-long-strings.diff
cd /opt/epics/extensions
# you can find the below file at https://raw.githubusercontent.com/stefco/geco_vm/27c2f597d2c29cd3f39e73ed0d905166a9e9a7ef/http/epics/distfiles/ubuntu-lib-locations.diff
patch -p0 < ../distfiles/ubuntu-lib-locations.diff
# NO NEED FOR THE MAC PATCH BELOW
# patch -p0 < ../distfiles/epics-patches-mac-10.9/darwin-lib-locations.diff
cd /opt/epics/extensions/src/medm$MEDM_VERSION/
patch -p0 < ../../../distfiles/epics-patches-mac-10.9/medm-long-strings.diff
# Apply a patch that is not listed on the LIGO instructions
# page but which can be found at:
# https://www.ligo-wa.caltech.edu/%7Ejonathan.hanks/epics/tgz/epics_remote_medm-2014-11-24.tar.gz
cd /opt/epics/extensions/src/medm$MEDM_VERSION/
# you can find the below file at https://raw.githubusercontent.com/stefco/geco_vm/27c2f597d2c29cd3f39e73ed0d905166a9e9a7ef/http/epics/distfiles/medm3_1_7_macrofile.patch
patch -p1 < /opt/epics/distfiles/medm3_1_7_macrofile.patch
# Apply remote screens patches
cd /opt/epics/extensions/src/medm$MEDM_VERSION/
wget --output-document=/opt/epics/distfiles/remote_adl-2015-01-05.patch \
    https://www.dropbox.com/s/bw8pgymaytjv1q2/remote_adl-2015-01-05.patch?dl=0
    # this is password protected, but is the original source:
    # https://www.ligo-wa.caltech.edu/~jonathan.hanks/epics/tgz/remote_adl-2015-01-05.patch
wget --output-document=/opt/epics/distfiles/remote_adl-2015-01-05-to-2015-06-26.delta.patch \
    https://www.dropbox.com/s/jj60h0uxc67nl68/remote_adl-2015-01-05-to-2015-06-26.delta.patch?dl=1
    # this is password protected, but is the original source:
    # https://www.ligo-wa.caltech.edu/~jonathan.hanks/epics/tgz/remote_adl-2015-01-05-to-2015-06-26.delta.patch
wget --output-document=/opt/epics/distfiles/remote_adl-2015-06-26-to-2015-06-29.delta.patch \
    https://www.dropbox.com/s/9qjg6igw7qqn3cj/remote_adl-2015-06-26-to-2015-06-29.delta.patch?dl=0
    # this is password protected, but is the original source:
    # https://www.ligo-wa.caltech.edu/~jonathan.hanks/epics/tgz/remote_adl-2015-06-26-to-2015-06-29.delta.patch
patch --verbose -p1 < /opt/epics/distfiles/remote_adl-2015-01-05.patch
patch --verbose -p1 < /opt/epics/distfiles/remote_adl-2015-01-05-to-2015-06-26.delta.patch
patch --verbose -p1 < /opt/epics/distfiles/remote_adl-2015-06-26-to-2015-06-29.delta.patch
# Build and install EPICS Base
# This requires build-essential packages, which get uninstalled by the
# provisioner during cleanup. If you are developing this package, you will need
# to reinstall them manually with
apt-get install -y -qq build-essential
cd -P /opt/epics/base/startup
export EPICS_HOST_ARCH=`./EpicsHostArch.pl`
echo Epics host architecture: $EPICS_HOST_ARCH
cd -P /opt/epics/base
# On Ubuntu, make is gnumake
make clean uninstall
make
# Update the extensions tree
cd /opt/epics/extensions/configure
make
# Build and Install MEDM
apt-get install -y -qq libx11-dev
apt-get install -y -qq libxt-dev
apt-get install -y -qq libxp-dev libxmu-dev libxpm-dev
apt-get install -y -qq xfonts-100dpi
cd /opt/epics/extensions/src/medm$MEDM_VERSION
make
# Build and Install ALH
cd /opt/epics/extensions/src/alh$ALARM_HANDLER_VERSION
make
# Build and Install Probe
cd /opt/epics/extensions/src/probe$PROBE_VERSION
make
# Download launcher scripts
wget --output-document="$HOME"/bin/medm_lho \
    https://www.dropbox.com/s/hg8m4gre82c8nxi/medm_lho.sh?dl=1
    # this is password protected, but is the original source:
    # https://www.ligo-wa.caltech.edu/~jonathan.hanks/epics/tgz/medm_lho.sh
wget --output-document="$HOME"/bin/medm_llo \
    https://www.dropbox.com/s/ghqhiiskfsyp5bp/medm_llo.sh?dl=1
    # this is password protected, but is the original source:
    # https://www.ligo-wa.caltech.edu/~jonathan.hanks/epics/tgz/medm_llo.sh
chmod +x -R "$HOME"/bin
# Configure the Login Shell
echo \# Set EPICS_HOST_ARCH for future sw builds/use >> $HOME/.bashrc
echo export EPICS_HOST_ARCH=$EPICS_HOST_ARCH >> $HOME/.bashrc
echo \# Update PATH to include EPICS binaries >> $HOME/.bashrc
echo export PATH=\$PATH:/opt/epics/base/bin/$EPICS_HOST_ARCH/ >> $HOME/.bashrc
echo export PATH=\$PATH:/opt/epics/extensions/bin/$EPICS_HOST_ARCH/ >> $HOME/.bashrc
# Delete source files to free up space
rm -rf /opt/epics/distfiles
cd /opt/epics/base && ls | sed '/bin/d' | sed '/lib/d' | xargs rm -rf
cd /opt/epics/extensions && ls | sed '/bin/d' | sed '/lib/d' | xargs rm -rf

# Make sure we recognize LHO and LLO epics channels in known_hosts
mkdir -p "${HOME}"/.ssh
ssh-keyscan lhoepics.ligo-wa.caltech.edu lloepics.ligo-la.caltech.edu >> "${HOME}"/.ssh/known_hosts
