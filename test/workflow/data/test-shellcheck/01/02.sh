#!/bin/bash
# shellcheck disable=SC2034

export WORKFLOW_ID="37075164"
export REF="actions"
export RUN_ID="test-shellcheck/01/02"
export DOCKERFILE_TEMPLATE="./_actions/docker/test-shellcheck.Dockerfile"
export DOCKERFILE="test-shellcheck.Dockerfile"
export WORK_DIR="/github/workspace/_actions"
export SCRIPT="./src/test-shellcheck.sh"
export ARGS="./src\\n./test"
