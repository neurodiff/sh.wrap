#!/bin/bash
# shellcheck disable=SC2034

export WORKFLOW_ID="38942441"
export REF="actions"
export RUN_ID="pandoc-convert/01/01"
export DOCKERFILE_TEMPLATE="./_actions/docker/pandoc-convert.Dockerfile"
export DOCKERFILE="pandoc-convert.Dockerfile"
export WORK_DIR="/github/workspace"
export SCRIPT="./_actions/src/pandoc-convert.sh"
export IN_DIR="./doc"
export OUT_DIR="./.doc-out"
export PANDOC_CLEAN="1"
export OUT_CACHE="pandoc-convert/01/01"
