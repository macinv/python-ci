#!/usr/bin/env bash
# Install miniconda and set up pypi credentials

set -e

wget "https://repo.anaconda.com/miniconda/Miniconda3-py39_${CONDA_VERSION}-0-Linux-x86_64.sh" \
    -O "miniconda_${CONDA_VERSION}.sh"
bash "miniconda_${CONDA_VERSION}.sh" -b -p "${HOME}/opt/conda"
export PATH="${HOME}/opt/conda/bin:${PATH}"
conda init bash
# shellcheck disable=SC1091
source "${HOME}/.bashrc"
conda config --set always_yes yes --set changeps1 no --set report_errors false

# note that libmamba-solver is now the default, so we don't need to install it

# Useful for debugging any issues with conda
conda info -a

pip install conda-lock==1.4.0

# set up pypi credentials
mkdir "${HOME}/.pip"
mv pip.conf "${HOME}/.pip/."
mv .pypirc "${HOME}/."
