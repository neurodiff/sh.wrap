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

gh_mode=0
# shellcheck disable=SC2153
[[ -v GH_MODE ]] && gh_mode=1

gh_echo() {
	local gh_commands

	[[ "$gh_mode" == 0 ]] && return 0;
	read -d $'\0' -r gh_commands || true;
	echo -en "${gh_commands}\n"
}

help-org-to-md() {
	printf "Usage: %s: <INDIR> <OUTDIR> [CLEAN]\n" "$0"
	help "$@"
}

# check source directory
if [[ $# -eq 0 ]]; then
	echo >&2 "No source directory specified"
	help-org-to-md "$@"
fi
# check destination directory
if [[ $# -eq 1 ]]; then
	echo >&2 "No destination directory specified"
	help-org-to-md "$@"
fi

in_dir=$(realpath "$1")
out_dir=$(realpath "$2")
clean="$3"

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

# greetings for github runner
echo '::notice::Pandoc conversion action started!' | gh_echo

# generate documentation
echo '::group::Convert docs' | gh_echo
LAST_ERROR="conversion failed"
while IFS= read -d $'\0' -r path; do
	dir=$(dirname $(realpath -m -s "$path" --relative-base "$in_dir"))
	file=$(basename "$path")

	mkdir -p "$out_dir"/"$dir" || true 2> /dev/null
	org_to_md "$in_dir"/"$dir"/"$file" 1 > "$out_dir"/"$dir"/"${file%.org}.md" \
		|| $live_or_die
done < <(find "$in_dir" -name '*.org' -print0)
echo '::endgroup::' | gh_echo

# goodbye
echo '::notice::Pandoc conversion action ended!' | gh_echo

exit 0
