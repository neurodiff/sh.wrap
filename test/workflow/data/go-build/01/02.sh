#!/bin/bash
# shellcheck disable=SC2034

export WORKFLOW_ID="38942439"
export REF="actions"
export RUN_ID="go-build/01/02"
export DOCKERFILE_TEMPLATE="./_actions/docker/go-build.Dockerfile"
export DOCKERFILE="go-build.Dockerfile"
export WORK_DIR="/github/workspace"
export SCRIPT="./_actions/src/go-build.sh"
export GIT_PATH="./"
export GIT_REPO="https://github.com/cli/cli"
export GIT_HASH="7d71f807c48600d0d8d9f393ef13387504987f1d"
export BUILD_ARGS=""
export GO_BIN="./cli/bin"
export USE_CACHE=false
