#!/usr/bin/env bash
#

set -xEeuo pipefail

echo "START of START_TASK"

echo "Current user is: $(whoami)"
echo "Current working directory is: $(pwd)"
echo "The env variables are:"
echo
env | sort
echo
getent passwd
echo
echo "Install dependencies"
sudo apt -yq update
sudo apt install -yq \
  silversearcher-ag \
  nfs-common \
;

echo
echo "Setup conda"
wget -O ~/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash ~/miniconda.sh -b -p ~/miniconda
eval "$(~/miniconda/condabin/conda shell.bash hook)"
source ~/miniconda/etc/profile.d/conda.sh
which conda

echo "Setup conda env"
conda create --name schism_env "pschism=5.9*=mpi_mpich*"
conda activate schism_env
which schism

echo "Mount Blob over nfs"
sudo mkdir -p /blob
# sudo mount -o sec=sys,vers=3,nolock,proto=tcp sabatchd75dposeidondev.blob.core.windows.net:/sabatchd75dposeidondev/test-nfs /blob
sudo mount -t nfs -o vers=3,rsize=1048576,wsize=1048576,hard,nolock,proto=tcp,nconnect=8 sabatchd75dposeidondev.blob.core.windows.net:/sabatchd75dposeidondev/test-nfs /blob
sudo chmod o+rx /blob
sudo mkdir /blob/pool_output
sudo chown batchadmin:batchadmin /blob/pool_output

echo "End of START_TASK"
