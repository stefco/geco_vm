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
    if ! [ -e "./$line" ]; then
        cp -n -v -R "$path_to_bento/$line" "./$line"
    fi
done <<__FILE_LIST__
ubuntu-12.04-amd64.json
http/ubuntu-12.04
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

rm .bento-version
echo `cd "$path_to_bento" && git rev-parse HEAD` \
     > .bento-version

cat <<__BENTO_NOTES__

Things you still have to do:

edit memory to 1024
and cpus to 2
then add in provisioning script
do not use the cleanup script, since dev libs can be good
remove parallels-iso, which can only be built on darwin

__BENTO_NOTES__
