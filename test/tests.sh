#!/bin/bash

set -o errexit

help() {
	printf "Usage: %s: SRCDIR..." "$0"
	echo "$*" >&2
	exit 1
}

if [[ $# -eq 0 ]]; then
	echo >&2 "No source directories specified"
	help "$@"
fi

# goto sources
work_dir=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
cd "$work_dir"/..

# scan for `sh` files in specified directories
files=()
for src_dir in "$@"; do
	while IFS=$'\0' read -d $'\0' -r src_file; do
		files+=("$src_file")
	done < <(find ./"$src_dir" -name '*.sh' -print0)
done

# run shellcheck
shellcheck -f gcc "${files[@]}"
