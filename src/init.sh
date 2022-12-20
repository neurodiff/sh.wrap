#!/bin/bash
# sh.wrap - module system for bash

# init.sh
# Initialization script intended to be in user shell profile.

[[ -n "${SHWRAP_INIT_DIR}" ]] || SHWRAP_INIT_DIR="${BASH_SOURCE[0]}"
declare -x SHWRAP_INIT_DIR

# shellcheck source=src/common.sh
source "${SHWRAP_INIT_DIR}"/module.sh

shwrap_import sh.wrap/module.sh
