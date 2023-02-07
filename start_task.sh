#!/usr/bin/env bash
#

set -xEeuo pipefail

whoami

env | sort

: "Install dependencies"
sudo apt -yq update
sudo apt install -yq \
  silversearcher-ag \
  nfs-common \
;

: "Mount Blob over nfs"
sudo mkdir -p /blob
# sudo mount -o sec=sys,vers=3,nolock,proto=tcp sabatchd75dposeidondev.blob.core.windows.net:/sabatchd75dposeidondev/test-nfs /blob
sudo mount -t nfs -o vers=3,rsize=1048576,wsize=1048576,hard,nolock,proto=tcp,nconnect=8 sabatchd75dposeidondev.blob.core.windows.net:/sabatchd75dposeidondev/test-nfs /blob
sudo chmod o+rx /blob
sudo mkdir /blob/pool_output
sudo chown batchadmin:batchadmin /blob/pool_output
