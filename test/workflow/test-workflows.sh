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

declare xtrace
reset_xtrace() {
	xtrace=$(set -o | grep "xtrace" | grep "on" || true)
	set +o xtrace
}
restore_xtrace()
{
	set "${xtrace:-+}"o xtrace
	set "${xtrace:+-}"o xtrace
	xtrace=
}

help-test-workflows() {
	printf "Usage: %s: <GITHUBREPO> <DATADIRS...>\n" "$0"
	help "$@"
}

# check github repository (OWNER/REPO format)
if [[ $# -eq 0 ]]; then
	echo >&2 "No github repository specified"
	help-test-workflows "$@"
fi
github_repo="$1"
shift 1

# check data directories
if [[ $# -eq 0 ]]; then
	echo >&2 "No data directories specified"
	help-test-workflows "$@"
fi
reset_xtrace
gh_token="${GITHUB_TOKEN}"
restore_xtrace

# check paths
LAST_ERROR="authentication token is empty"
reset_xtrace
[[ -n "$gh_token" ]] || $live_or_die
restore_xtrace

# fill in data directories
declare -a data_dirs
if [[ "$gh_mode" == 1 ]]; then
	readarray -t -d $'\n' data_dirs < <(echo -e "$@")
else
	data_dirs+=("$@")
fi

function test_workflow()
{
	local data_template="$1"
	local datafile="$2"
	# shellcheck disable=SC1090
	source "$datafile"
	local API_WORKFLOW_DISPATCH="https://api.github.com/repos/${github_repo}/actions/workflows/${WORKFLOW_ID}/dispatches"
	LAST_ERROR="${data_template} (${datafile}): test dispatch failed"
	env envsubst < "$data_template" | \
		jq '{ ref: .ref, inputs: { run_id: .inputs.run_id, payload: (.inputs.payload | tostring) }}' | \
		curl -X POST "${API_WORKFLOW_DISPATCH}" --fail \
			 -H "Authorization: Bearer ${gh_token}" \
			 -H "Accept: application/vnd.github+json" \
			 -d @- || $live_or_die
}

data_templates=()
for data_dir in "${data_dirs[@]}"; do
	while IFS=$'\0' read -d $'\0' -r data_template; do
		data_templates+=("$data_template")
	done < <(find "$data_dir" -name '*.json' -print0)
done

for data_template in "${data_templates[@]}"; do
	data_path="${data_template%.json}"
	while IFS=$'\0' read -d $'\0' -r datafile; do
		test_workflow "$data_template" "$datafile"
	done < <(find "$data_path" -name '*.sh' -print0)
done

exit 0
