#!/bin/bash

set -o errexit

help() {
	echo "$*" >&2
	exit 1
}

help-entrypoint() {
	printf "Usage: %s: <WORKDIR> <SCRIPT> <ARGS...>\n" "$0"
	help "$@"
}

# check working directory
if [[ $# -eq 0 ]]; then
	echo >&2 "No working directory specified"
	help-entrypoint "$@"
elif [[ $# -eq 1 ]]; then
	echo >&2 "No script specified"
	help-entrypoint "$@"
fi

work_dir=$(realpath "$1")
script="$2"
shift 2

cd "$work_dir"
bash "$script" "$@"
