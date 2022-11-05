#!/bin/bash
# shellcheck disable=SC2034

export WORKFLOW_ID="39688674"
export REF="actions"
export RUN_ID="pandoc-convert/01/01"
export DOCKERFILE_TEMPLATE="./_actions/docker/pandoc-convert.Dockerfile"
export DOCKERFILE="pandoc-convert.Dockerfile"
export WORK_DIR="/github/workspace"
export SCRIPT="./_actions/src/org-to-md.sh"
export IN_DIR="./test/pandoc-convert"
export OUT_DIR="./.doc-out"
export PANDOC_CLEAN="1"
export OUT_CACHE="pandoc-convert-01-01"
export OUT_CACHE_DIR="./.doc-out"
