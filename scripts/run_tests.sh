#!/usr/bin/env bash
# Run tests.

set -e

# keep this to allow this script to be run through command bash
eval "$(micromamba shell hook -s posix)"

micromamba activate "${PACKAGE_NAME}"

if [ "$ENSURE_PYTEST_USES_INSTALLED_VERSION" = "1" ]; then mv "${PACKAGE_NAME}" "_${PACKAGE_NAME}"; fi
python -c "import ${PACKAGE_NAME}; print(${PACKAGE_NAME}.__file__, ${PACKAGE_NAME}.__version__)"

black --check .
pylint -f parseable "${PACKAGE_NAME}" | tee pylint.out

# we might need to override the pytest line
if [ -f run_tests_override.sh ]; then
    ./run_tests_override.sh
else
    python -m pytest \
        --ignore tests/ignore --ignore tests/integration \
        -n auto \
        -v -rw --cov="${PACKAGE_NAME}" --cov-report term-missing --cov-report xml -m "not integration"
fi

if [ "$ENSURE_PYTEST_USES_INSTALLED_VERSION" = "1" ]; then mv "_${PACKAGE_NAME}" "${PACKAGE_NAME}"; fi

micromamba deactivate
