#!/bin/bash

set -o errexit

[[ -v LIVE_DEBUG ]] && set -o xtrace

help() {
	echo "$*" >&2
	exit 1
}

die() {
	printf "%s: ${LAST_ERROR}\n" "$0" >&2
	exit 1
}
live() {
	true
}
live_or_die=${LIVE_OR_DIE:-die}

LAST_ERROR=
trap '$live_or_die' ERR

help-org-to-md() {
	printf "Usage: %s: <ORGFILE> [CLEAN]\n" "$0"
	help "$@"
}

# check github repository (OWNER/REPO format)
if [[ $# -eq 0 ]]; then
	echo >&2 "No org file specified"
	help-org-to-md "$@"
fi
org_file="$1"
clean="$2"

LAST_ERROR="convertation failed"

function org_to_md()
{
	local page="$1"
	local clean="$2"
	local extensions=""
	if [[ "$clean" == 1 ]]; then
		extensions="-raw_attribute-raw_html-header_attributes-bracketed_spans"
	fi
	extensions+="+hard_line_breaks"
	pandoc -s "$page" -t markdown"$extensions" --wrap=none
}

org_to_md "$org_file" "$clean" || $live_or_die

exit 0
