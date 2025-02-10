#!/usr/bin/env bash
# Install miniconda and set up pypi credentials

set -e

export MAMBA_ROOT_PREFIX="${HOME}/opt/micromamba"
export PREFIX_LOCATION="${MAMBA_ROOT_PREFIX}"
export BIN_FOLDER="${MAMBA_ROOT_PREFIX}/bin"
export INIT_YES="Y"
export CONDA_FORGE_YES="Y"

curl -L micro.mamba.pm/install.sh -o install_micromamba.sh

# < /dev/null ensures we run in noninteractive mode
bash ./install_micromamba.sh < /dev/null


export PATH="${BIN_FOLDER}:${PATH}"

# shellcheck disable=SC1091
source "${HOME}/.bashrc"
micromamba activate
micromamba config set always_yes true


# useful for debugging
micromamba info 
micromamba config list

# we can use conda-lock (it's MIT-licensed)
micromamba install python=3.12
python -m pip install conda-lock==1.4.0
micromamba list

# set up pypi credentials
mkdir "${HOME}/.pip"
mv pip.conf "${HOME}/.pip/."
mv .pypirc "${HOME}/."
