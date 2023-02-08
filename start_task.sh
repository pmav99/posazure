#!/usr/bin/env bash
#

set -Eeuo pipefail

log() {
  printf '%s - %05d sec - %s\n' "$(date +'%T.%3N')" ${SECONDS} "${1}"
  SECONDS=0
}


echo
log "START of START_TASK"
echo

log "Current user is: $(whoami)"
log "Current working directory is: $(pwd)"
log "The env variables are:"
echo
env | sort
echo
getent passwd
echo

log "Test sudo access"
sudo touch /dev/null


log "Install dependencies"
sudo apt -yq update
sudo apt install -yq \
  silversearcher-ag \
  nfs-common \
;

echo
log "Setup conda"
wget https://raw.githubusercontent.com/pmav99/posazure/master/condarc -O ~/.condarc
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -b -p ~/miniconda
eval "$(~/miniconda/condabin/conda shell.bash hook)"
source ~/miniconda/etc/profile.d/conda.sh
which conda

log "Setup conda env"
conda create --quiet --name schism_env "pschism=5.9*=mpi_mpich*"

log "Test conda env"
conda activate schism_env
which schism

log "Mount Blob over nfs"
sudo mkdir -p /blob
# sudo mount -o sec=sys,vers=3,nolock,proto=tcp sabatchd75dposeidondev.blob.core.windows.net:/sabatchd75dposeidondev/test-nfs /blob
sudo mount -t nfs -o vers=3,rsize=1048576,wsize=1048576,hard,nolock,proto=tcp,nconnect=8 sabatchd75dposeidondev.blob.core.windows.net:/sabatchd75dposeidondev/test-nfs /blob
sudo chmod o+rx /blob
sudo mkdir -p /blob/pool_output
sudo chown $(id -u):$(id -g) /blob/pool_output

log "END of START_TASK"
