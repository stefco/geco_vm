# when installing with packer, move files from /tmp
mkdir -p /opt
mv /tmp/epics /opt

# add in extra files, like .bashrc and scripts in ~/bin
if [ -e /tmp/.bashrc ]; then
    cat /tmp/.bashrc >> "$HOME"/.bashrc
fi
if [ -e /tmp/bin ]; then
    if ! [ -e "$HOME"/bin ]; then
        mkdir "$HOME"/bin
    fi
    mv --no-clobber /tmp/bin/* "$HOME"/bin
    chmod +x -R "$HOME"/bin
    echo export PATH=\"/vagrant:$HOME/bin:\$PATH\" >> ~/.bashrc
fi
