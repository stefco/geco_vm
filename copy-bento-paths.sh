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

# make necessary directories
mkdir -p floppy scripts/common scripts/ubuntu http

while read line; do
    cp -v -R "$path_to_bento/$line" "./$line"
done <<__FILE_LIST__
ubuntu-12.04-amd64.json
http
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

printf "\nThings you still have to do:\n\n"

cat bento-notes

echo
