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

help-gh-publish() {
	printf "Usage: %s: <GHPATH> <GHPAGESREPO> <GHPAGESBRANCH> <PUBLICDIR>\n" "$0"
	help "$@"
}

echo '::notice::GH publish action started!' | gh_echo

# check parameters
if [[ $# -eq 0 ]]; then
	echo >&2 "No gh binary path specified"
	help-gh-publish "$@"
fi

if [[ $# -eq 1 ]]; then
	echo >&2 "No gh-pages repository specified"
	help-gh-publish "$@"
fi

if [[ $# -eq 2 ]]; then
	echo >&2 "No gh-pages branch specified"
	help-gh-publish "$@"
fi

if [[ $# -eq 3 ]]; then
	echo >&2 "No publish directory specified"
	help-gh-publish "$@"
fi

gh_bin=$(realpath "$1")
gh_pages_repo="$2"
gh_pages_branch="$3"
public_dir=$(realpath "$4")
reset_xtrace
gh_token="${GITHUB_TOKEN}"
restore_xtrace

# check paths
LAST_ERROR="gh binary not found"
[[ -f "$gh_bin" ]] || $live_or_die
LAST_ERROR="publish directory not found"
[[ -d "$public_dir" ]] || $live_or_die
# check token
LAST_ERROR="authentication token is empty"
reset_xtrace
[[ -n "$gh_token" ]] || $live_or_die
restore_xtrace

# authenticate with token
LAST_ERROR="authentication failed"
chmod u+x "$gh_bin"
unset GITHUB_TOKEN
GIT_DIR=.nogit "$gh_bin" auth login --git-protocol https --with-token <<< "$gh_token"
GIT_DIR=.nogit "$gh_bin" auth setup-git

echo '::group::Push site to GH pages' | gh_echo

# publish site
if [[ "${GITHUB_EVENT_NAME}" == "push" ]] || [[ "${GITHUB_EVENT_NAME}" == "workflow_dispatch" ]]; then
	LAST_ERROR="publish site failed"
	pushd "$public_dir"
	git init
	git config --global --add safe.directory "$public_dir" || $live_or_die
	git config user.name "gh-publish action"
	git config user.email "nobody@nowhere"
	git checkout -b "$gh_pages_branch" || $live_or_die
	git remote add -t "$gh_pages_branch" "origin" "$gh_pages_repo" || $live_or_die
	git add .
	git commit --allow-empty -m "pages: update gh pages" \
		--author="gh-publish action <nobody@nowhere>" || $live_or_die
	git push "origin" "$gh_pages_branch" --force || $live_or_die
	popd
fi

echo '::endgroup::' | gh_echo

echo '::notice::GH publish action ended!' | gh_echo
