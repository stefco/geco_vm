#!/bin/bash

# copy things from bento

set -o nounset
set -o errexit
set -o noclobber

USAGE="$0 path_to_bento"

if [ "$#" == "0" ]; then
    echo "$USAGE"
    exit 1
fi

path_to_bento="$1"

while read line; do
    cp -v -R "$path_to_bento/$line" .
done <<__FILE_LIST__
ubuntu-12.04-amd64.json
http/
VBoxGuestAdditions_*.iso
.vbox_version
floppy/dummy_metadata.json
scripts/common/metadata.sh
scripts/ubuntu/update.sh
scripts/common/sshd.sh
scripts/ubuntu/networking.sh
scripts/ubuntu/sudoers.sh
scripts/ubuntu/vagrant.sh
scripts/common/vmtools.sh
scripts/ubuntu/cleanup.sh
scripts/common/minimize.sh
__FILE_LIST__

mv -v "ubuntu-12.04-amd64.json" "geco-vm.json"

printf "\nThings you still have to do:\n\n"

cat bento-notes
