#!/bin/bash
# sh.wrap - module system for bash

# module.sh
# Core of sh.wrap module system.

# shellcheck source=src/util.sh
source "${SHWRAP_INIT_DIR}"/util.sh
# shellcheck source=src/common.sh
source "${SHWRAP_INIT_DIR}"/common.sh
# shellcheck source=src/import.sh
source "${SHWRAP_INIT_DIR}"/import.sh
# shellcheck source=src/run.sh
source "${SHWRAP_INIT_DIR}"/run.sh
# shellcheck source=src/search.sh
source "${SHWRAP_INIT_DIR}"/search.sh
