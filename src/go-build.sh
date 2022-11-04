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

LAST_ERROR="git config failed"
git_config_backup="$(touch ~/.gitconfig; cat ~/.gitconfig)"

quit-git() {
	cat <<< "$git_config_backup" > ~/.gitconfig
}

trap 'quit-git' EXIT

back() {
	while popd; do :; done 2> /dev/null
	return 0
}

trap 'back' EXIT

gh_mode=0
# shellcheck disable=SC2153
[[ -v GH_MODE ]] && gh_mode=1

gh_echo() {
	local gh_commands

	[[ "$gh_mode" == 0 ]] && return 0;
	read -d $'\0' -r gh_commands || true;
	echo -en "${gh_commands}\n"
}

help-go-build() {
	printf "Usage: %s: <GITPATH> <GITREPO> <GITHASH> [BUILDARGS...]\n" "$0"
	help "$@"
}

# greetings for github runner
echo '::notice::Go build action started!' | gh_echo

# check parameters
if [[ $# -eq 0 ]]; then
	echo >&2 "No git repository destination specified"
	help-go-build "$@"
fi

if [[ $# -eq 1 ]]; then
	echo >&2 "No git repository url specified"
	help-go-build "$@"
fi

if [[ $# -eq 2 ]]; then
	echo >&2 "No git commit hash specified"
	help-go-build "$@"
fi

# check working directory
git_path=$(realpath "$1")
git_repo="$2"
git_hash="$3"
shift 3

declare -a build_args
if [[ "$gh_mode" == 1 ]]; then
	readarray -t -d $'\n' build_args < <(echo -e "$@")
else
	build_args+=("$@")
fi

LAST_ERROR="working directory is invalid"
[[ -d "$git_path" ]] || $live_or_die

git_repo_dir=$(realpath "$git_path"/"${git_repo##*/}")
export GOPATH="$git_repo_dir"/.go
export GOCACHE="$git_repo_dir"/.cache

echo '::group::Clone repository' | gh_echo

LAST_ERROR="git repository safe.directory configuration failed"
# fixes go build with -buildvcs option in unsafe git directories
GIT_DIR=.nogit git config --global --add safe.directory "$git_repo_dir" || $live_or_die

# clone go repo
mkdir -p "$git_repo_dir" || $live_or_die
git -C "$git_repo_dir" init || $live_or_die
git -C "$git_repo_dir" remote add origin "$git_repo" || $live_or_die
git -C "$git_repo_dir" pull --depth=1 origin "$git_hash"

echo '::endgroup::' | gh_echo

echo '::group::Build go binary' | gh_echo

# build hugo
LAST_ERROR="change directory to '${git_repo_dir}' failed"
pushd "$git_repo_dir" || $live_or_die

LAST_ERROR="go build failed"
{
	if [[ -f Makefile ]]; then
		make -k -B
	else
		go build -ldflags "-s -w" "${build_args[@]}"
	fi
} || $live_or_die

popd

echo '::endgroup::' | gh_echo

# goodbye
echo '::notice::Go build action ended!' | gh_echo
