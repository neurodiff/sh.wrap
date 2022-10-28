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

help-docsy-site() {
	printf "Usage: %s: <HUGOPATH> <DOCSDIR> <SITEDIR> <PUBLICDIR>\n" "$0"
	help "$@"
}

# greetings for github runner
echo '::notice::Docsy site export started!' | gh_echo

# check parameters
if [[ $# -eq 0 ]]; then
	echo >&2 "No arguments specified"
	help-docsy-site "$@"
fi

help-hugo-site() {
	printf "Usage: %s: <HUGOPATH> <DOCSDIR> <SITEDIR> <PUBLICDIR>\n" "$0"
	help "$@"
}
# check parameters
if [[ $# -eq 0 ]]; then
	echo >&2 "No hugo binary path specified"
	help-hugo-site "$@"
fi

if [[ $# -eq 1 ]]; then
	echo >&2 "No documentation directory specified"
	help-hugo-site "$@"
fi

if [[ $# -eq 2 ]]; then
	echo >&2 "No site directory specified"
	help-hugo-site "$@"
fi

if [[ $# -eq 3 ]]; then
	echo >&2 "No publish directory specified"
	help-hugo-site "$@"
fi

hugo_bin=$(realpath "$1")
docs_dir=$(realpath "$2")
site_dir=$(realpath "$3")
public_dir=$(realpath "$4")

LAST_ERROR="docsy site export failed"
echo '::group::Install docsy theme dependencies' | gh_echo
nvm &> /dev/null || git clone --depth=1 -b v0.39.2 https://github.com/nvm-sh/nvm ~/.nvm || $live_or_die
# shellcheck disable=SC1090
source ~/.nvm/nvm.sh
nvm use 18 || { nvm install 18; nvm use 18; } || $live_or_die
# get npm modules
pushd "${site_dir}/themes/docsy"
npm install || $live_or_die
popd
npm install --save-dev autoprefixer postcss-cli postcss || $live_or_die
echo '::endgroup::' | gh_echo

bash "${DOCKERFILE_SCRIPTS_PATH}"/hugo-site.sh  "$hugo_bin" "$docs_dir" "$site_dir" "$public_dir"

# goodbye
echo '::notice::Docsy site export ended!' | gh_echo
