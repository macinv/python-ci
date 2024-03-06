.PHONY: pre-commit check-scripts
SHELL := /bin/bash
PRECOMMIT_VERSION="3.6.0"

pre-commit:
	wget -O pre-commit.pyz https://github.com/pre-commit/pre-commit/releases/download/v${PRECOMMIT_VERSION}/pre-commit-${PRECOMMIT_VERSION}.pyz
	python3 pre-commit.pyz install
	rm pre-commit.pyz

check-scripts:
	shellcheck scripts/*.sh
