#!/usr/bin/env bash
# Merge master into dev. This should be used after a successful deployment in master.

set -e

export GIT_COMMITTER_EMAIL="travis@travis-ci.com"
export GIT_COMMITTER_NAME="Travis CI"

export tmp_dir="${HOME}/tmp"
git clone --branch master "https://${GITHUB_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git" "${tmp_dir}" >/dev/null 2>&1
cd "${tmp_dir}" || exit 1
git checkout dev
git merge --no-edit master

# redirect to /dev/null to avoid leaking the token
git push origin dev >/dev/null 2>&1
