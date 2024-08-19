#!/usr/bin/env bash
# Merge master into dev. This should be used after a successful deployment in master.

set -e

export GIT_COMMITTER_EMAIL="travis@travis-ci.com"
export GIT_COMMITTER_NAME="Travis CI"

export tmp_dir="${HOME}/tmp"
export SOURCE_BRANCH=master
export TARGET_BRANCH=dev
# note: Travis suppresses the github token from the output (it shows as [secure])
export REPO_URL="https://${GITHUB_TOKEN}:x-oauth-basic@github.com/${TRAVIS_REPO_SLUG}.git"

git --version

git clone --branch ${SOURCE_BRANCH} "${REPO_URL}" "${tmp_dir}" 2>&1
cd "${tmp_dir}" || exit 1

echo "setting remote origin.."
git remote set-url origin "${REPO_URL}"
git config --list
git remote -v

# show recent commits
echo "last commits in ${SOURCE_BRANCH}:"
git log -n 3 --oneline

echo "fetching target branch ${TARGET_BRANCH}"
git fetch origin ${TARGET_BRANCH}

echo "checking out the target branch ${TARGET_BRANCH}"
git checkout ${TARGET_BRANCH}

echo "last commits in ${TARGET_BRANCH} before merge:"
git log -n 3 --oneline

echo "merging ${SOURCE_BRANCH} into ${TARGET_BRANCH}"
git merge --no-edit ${SOURCE_BRANCH}

echo "last commits in ${TARGET_BRANCH} after merge:"
git log -n 3 --oneline

echo "pushing to remote ${TARGET_BRANCH}"
GIT_TRACE=1 GIT_CURL_VERBOSE=1 git push --verbose "${REPO_URL}" ${TARGET_BRANCH} 2>&1
