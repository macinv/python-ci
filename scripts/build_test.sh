#!/usr/bin/env bash
# Test building the conda environment and the Python package.

set -e

CUR_DIR=${PWD}
CACHED_ENV_DIR="${HOME}/.cache/envs"

# Note: keep this line to allow this script to be run through bash
eval "$(micromamba shell hook -s posix)"

# lock only conda dependencies and leave out the pip dependencies
sed '/pip:/Q' env.yml > env-conda.yml
md5_hash=$(md5sum env-conda.yml | awk '{ print $1 }')
echo "env-conda.yml: ${md5_hash}"
locked_env_yml="conda-lock-${md5_hash}.yml"
if [ -f "${CACHED_ENV_DIR}/${locked_env_yml}" ]; then
    cp "${CACHED_ENV_DIR}/${locked_env_yml}" "${locked_env_yml}"
fi
if [ -f "${locked_env_yml}" ]; then
    echo "${locked_env_yml} already exists."
    cp "${locked_env_yml}" "conda-lock.yml"
else
    conda-lock -f env-conda.yml -p linux-64 --lockfile "conda-lock.yml"
    cp "conda-lock.yml" "${locked_env_yml}"
fi

# Note: this only works if the yaml file is named "conda-lock.yml"
micromamba create --name "${PACKAGE_NAME}" -f conda-lock.yml

micromamba activate "${PACKAGE_NAME}"
python -m pip install -r requirements.txt
python -m build
python -m pip install "dist/$(find ./dist/*.whl -printf %f)"

if [ "${TRAVIS}" = true ] && [ ! -f "${CACHED_ENV_DIR}/${locked_env_yml}" ]; then
    # copy to cache
    cp "conda-lock.yml" "${CACHED_ENV_DIR}/${locked_env_yml}"
fi

# cd to root directory to make sure the pip installed copy is used
cd /
python -c "import ${PACKAGE_NAME}; print(${PACKAGE_NAME}.__version__); print(${PACKAGE_NAME})"
cd "${CUR_DIR}
micromamba deactivate
