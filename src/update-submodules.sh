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

help-git-submodule() {
	printf "Usage: %s: <GHBIN> <GITREPO> <GITBRANCH> <GITDIR> [GITAMEND]\n" "$0"
	help "$@"
}

echo '::notice::git submodules update started!' | gh_echo

# check parameters
if [[ $# -eq 0 ]]; then
	echo >&2 "No gh binary path specified"
	help-git-submodule "$@"
fi

if [[ $# -eq 1 ]]; then
	echo >&2 "No git repository specified"
	help-git-submodule "$@"
fi

if [[ $# -eq 2 ]]; then
	echo >&2 "No git branch specified"
	help-git-submodule "$@"
fi

if [[ $# -eq 3 ]]; then
	echo >&2 "No git path specified"
	help-git-submodule "$@"
fi

gh_bin=$(realpath "$1")
git_repo="$2"
git_branch="$3"
git_repo_dir=$(realpath "$4")
git_amend="$5"
reset_xtrace
gh_token="${GITHUB_TOKEN}"
restore_xtrace

# check paths
LAST_ERROR="gh binary not found"
[[ -f "$gh_bin" ]] || $live_or_die
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

echo '::group::Update git submodules' | gh_echo

# update git submodules
LAST_ERROR="git submodules update failed"
git clone -b "$git_branch" "$git_repo" "$git_repo_dir" || $live_or_die
pushd "$git_repo_dir"
git config --global --add safe.directory "$git_repo_dir" || $live_or_die
git config user.name "git-submodule action"
git config user.email "nobody@nowhere"
git submodule update --init --force --remote --recursive
git add .
git commit ${git_amend:+--amend} --allow-empty -m "actions: update git submodules" \
	--author="git-submodule action <nobody@nowhere>" || $live_or_die
git push "origin" "$git_branch" --force
popd

echo '::endgroup::' | gh_echo

echo '::notice::git submodules update ended!' | gh_echo
