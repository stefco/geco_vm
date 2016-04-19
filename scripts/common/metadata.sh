#!/bin/sh -eux

mkdir -p /etc;
cp /tmp/geco-metadata.json /etc/geco-metadata.json;
chmod 0444 /etc/geco-metadata.json;
rm -f /tmp/geco-metadata.json;
