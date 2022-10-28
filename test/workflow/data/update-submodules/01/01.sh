#!/bin/bash
# shellcheck disable=SC2034

export WORKFLOW_ID="37251119"
export REF="actions"
export RUN_ID="update-submodules/01/01"
export DOCKERFILE_TEMPLATE="./_actions/docker/git-tasks.Dockerfile"
export DOCKERFILE="git-tasks.Dockerfile"
export WORK_DIR="/github/workspace/_actions"
export SCRIPT="./src/update-submodules.sh"
export GH_BIN_SOURCE="./cli/bin/gh"
export GH_BIN_DEST="/go/gh"
export GH_BIN_PATH="./cli/bin"
export GH_REPO="https://github.com/cli/cli"
export GH_HASH="7d71f807c48600d0d8d9f393ef13387504987f1d"
export GH_BUILD_ARGS=""
export GIT_REPO="https://github.com/ekotik/sh.wrap"
export GIT_BRANCH="gh-pages/sh.wrap"
export GIT_REPO_DIR="gh-pages-sh.wrap"
