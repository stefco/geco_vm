#!/bin/bash

# delete things that were just copied from bento

set -o nounset
set -o errexit
set -o noclobber

while read line; do
    rm -v -r -f "$line"
done <<__FILE_LIST__
ubuntu-12.04-amd64.json
http
floppy
scripts/common
scripts/ubuntu
.bento-version
__FILE_LIST__
