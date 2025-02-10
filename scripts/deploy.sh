#!/usr/bin/env bash
# Deploy built Python package to PYPI.

set -e

python -m pip install twine
python -m pip install build

python -m build
twine upload -r "${PYPI_REPO}" -u "${PYPI_USER}" -p "${PYPI_PASSWORD}" dist/*
