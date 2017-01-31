# when installing with packer, move files from /tmp

# for .bashrc, concatenate the default OS .bashrc to the start
if [ -e /tmp/HOME/.bashrc ]; then
    cat "${HOME}"/.bashrc /tmp/HOME/.bashrc > /tmp/bashrc-tmp \
        && mv /tmp/bashrc-tmp /tmp/HOME/.bashrc
fi

# now copy everything in the home directory recursively
if [ -e /tmp/HOME ]; then
    # this sneakily copies the contents of /tmp/HOME into ${HOME}
    cp -R /tmp/HOME/. "${HOME}"
fi

# make a directory for executables if it doesn't exist already (though it was
# likely copied over in the last step)
if ! [ -e "$HOME"/bin ]; then
    mkdir "$HOME"/bin
fi

# make ~/bin executable and add it to $PATH on login
chmod +x -R "$HOME"/bin
echo export PATH=\"/vagrant:${HOME}/bin:\$PATH\" >> ~/.bashrc

# make desktop files executable
chmod -R +x "${HOME}"/.medm_launcher/*desktop

# change ownership of home folder to vagrant
chown -R vagrant "${HOME}"
