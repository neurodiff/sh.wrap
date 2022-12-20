#!/bin/bash
# sh.wrap - module system for bash

# util.sh
# Utility functions.

function __shwrap_scope()
{
	declare -p | grep -vE '_+shwrap_.*|_+SHWRAP_.*|BASHOPTS|BASH_ARGC|BASH_ARGV|BASH_LINENO|BASH_SOURCE|BASH_VERSINFO|EUID|FUNCNAME|GROUPS|PPID|SHELLOPTS|UID' | __shwrap_declare
}

function __shwrap_declare()
{
	sed -e 's/declare --/declare -g/' |
		sed -E 's/declare -([^ -]+)/declare -\1g/'
}

function __shwrap_name_is_function()
{
	local __shwrap_name="$1"
	declare -F "${__shwrap_name}" > /dev/null
}

function __shwrap_log()
{
	local message="$*"
	[[ -n "${SHWRAP_MODULE_LOG}" ]] && echo "${message}"
}

function __shwrap_random_bytes()
{
	local count="$1"
	dd if=/dev/urandom bs=1 count="${count}" 2>/dev/null
}

function __shwrap_md5sum()
{
	md5sum | cut -d $' ' -f1
}

function __shwrap_fd_is_free()
{
	local fd="$1"
	if [[ -e /proc/"$$"/fd/"${fd}" ]]; then
		return 1
	fi
	return 0
}

function __shwrap_get_fd()
{
	local fdr_start="$1"
	local fdr_end="$2"

	eval "${SHWRAP_FD_FUNC}" "${fdr_start}" "${fdr_end}"
}

function __shwrap_get_fd_random()
{
	local fdr_start="$1"
	local fdr_end="$2"
	local fdr_size=$(("${fdr_end}" - "${fdr_start}"))
	local __fd fd=-1
	local try=0 maxtry="${SHWRAP_FD_RANDOM_MAXTRY}"
	while [[ "$((try++))" -lt "${maxtry}" ]]; do
		__fd=$(("${RANDOM}" % "${fdr_size}" + "${fdr_start}"))
		if __shwrap_fd_is_free "${__fd}"; then
			fd="${__fd}"
			break
		fi
	done
	if [[ "${fd}" == -1 ]]; then
		__shwrap_log "__shwrap_get_fd: error: no free fd after '${maxtry}' tries" >&2
	fi
	echo "${fd}"
}

function __shwrap_get_fd_sequential()
{
	local fdr_start="$1"
	local fdr_end="$2"
	local __fd fd=-1
	for __fd in $(seq "${fdr_start}" "${fdr_end}" | head -n -1); do
		if [[ -v _shwrap_fds["${__fd}"] ]]; then
			continue
		fi
		fd="${__fd}"
		break
	done
	if [[ "${fd}" == -1 ]]; then
		__shwrap_log "__shwrap_get_fd: error: no free fd between '${fdr_start}' and '${fdr_end}'" >&2
	fi
	echo "${fd}"
}
