# when installing with packer, move files from /tmp

set -o noclobber

# put EPICS files where they need to be for installation
mkdir -p /opt
mv /tmp/epics /opt

# for .bashrc, just concatenate it onto the default .bashrc
if [ -e /tmp/HOME/.bashrc ]; then
    cat "${HOME}"/.bashrc /tmp/HOME/.bashrc > /tmp/HOME/.bashrc
fi

# copy the rest of the stuff in the home directory recursively
if [ -e /tmp/HOME ]; then
    # this sneakily copies the contents of /tmp/HOME into ${HOME}
    cp -R /tmp/HOME/. "${HOME}"
fi

# make a directory for executables if it doesn't exist already
if ! [ -e "$HOME"/bin ]; then
    mkdir "$HOME"/bin
fi

chmod +x -R "$HOME"/bin
echo export PATH=\"/vagrant:${HOME}/bin:\$PATH\" >> ~/.bashrc
