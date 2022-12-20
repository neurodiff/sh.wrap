#!/bin/bash
# sh.wrap - module system for bash

# run.sh
# Module runner and cache functions.

# shellcheck source=src/common.sh
source "${SHWRAP_INIT_DIR}"/common.sh

function shwrap_run()
{
	local __shwrap_module="$1"
	local command_string="$2"
	shift 2

	local __shwrap_module_path
	__shwrap_module_path=$(__shwrap_search "${__shwrap_module}")
	__shwrap_run "${__shwrap_module_path}" "${command_string}" "$@"
}

function __shwrap_run()
{
	local __shwrap_module_path="$1"
	local command_string="$2"
	shift 2

	local __shwrap_module_hash
	__shwrap_module_hash="${_shwrap_modules_hashes[${__shwrap_module_path}]}"
	__shwrap__run "${__shwrap_module_path}" "${__shwrap_module_hash}" "${command_string}" "$@"
}

function __shwrap__run()
{
	local __shwrap_module_path="$1"
	local __shwrap_scope="$2"
	local command_string="$3"
	shift 3

	local __shwrap_ret=1
	local command __shwrap_module_hash
	local fd_scope fd_scope_cap fd_out fd_out_cap
	__shwrap_module_hash="${_shwrap_modules_hashes[${__shwrap_module_path}]}"
	[[ -v _shwrap_modules["${__shwrap_module_hash}"] ]] || {
		_shwrap_modules+=(["${__shwrap_module_hash}"]="###INITIALIZE MODULE###;")
		__shwrap_cache "${__shwrap_module_path}" "${__shwrap_scope}"
	}
	fd_scope=$(__shwrap_get_fd "${SHWRAP_FD_RANGE[@]}")
	eval "exec ${fd_scope}< /dev/null"
	_shwrap_fds["${fd_scope}"]="${fd_scope}"
	fd_out=$(__shwrap_get_fd "${SHWRAP_FD_RANGE[@]}")
	eval "exec ${fd_out}< /dev/null"
	_shwrap_fds["${fd_out}"]="${fd_out}"
	__shwrap_log "__shwrap__run: fds ${_shwrap_fds[*]}" >&2

	# shellcheck disable=SC2016
	# intentional use of single quotes to avoid unwanted expansions
	command='${SHWRAP_MODULE_DEBUG:+set -x}
		'"$(declare -p _shwrap_modules)"'
		'"$(declare -p _shwrap_modules_deps)"'
		'"$(declare -p _shwrap_modules_hashes)"'
		'"$(declare -p _shwrap_modules_names)"'
		'"$(declare -p _shwrap_modules_partials)"'
		'"$(declare -p _shwrap_modules_parts)"'
		'"$(declare -p _shwrap_modules_paths)"'
		'"$(declare -p _shwrap_scope)"'
		'"$(declare -p _shwrap_fds)"'
		'"$(declare -p _shwrap_modules_stack)"'
		eval "${_shwrap_scope[.]}"
		source '"${SHWRAP_MODULE}"'
		source /dev/stdin <<< "${_shwrap_modules['"${__shwrap_module_hash}"']}"
		eval "${_shwrap_scope['"${__shwrap_scope}"']}"
		'"${command_string}"' "$@"
		declare __shwrap_ret=$?
		_shwrap_scope+=(['"${__shwrap_scope}"']=$(__shwrap_scope))
		{
			declare -p _shwrap_modules;
			declare -p _shwrap_modules_deps;
			declare -p _shwrap_modules_hashes;
			declare -p _shwrap_modules_names;
			declare -p _shwrap_modules_partials;
			declare -p _shwrap_modules_parts;
			declare -p _shwrap_modules_paths;
			declare -p _shwrap_scope;
			declare -p _shwrap_fds;
			declare -p _shwrap_modules_stack;
		} | __shwrap_declare >&'"${fd_scope}"'
		declare -p __shwrap_ret >&'"${fd_scope}"'
		exit ${__shwrap_ret}'
	{
		eval "exec ${fd_out}>&1"
		exec {fd_scope_cap}< <(
			exec {fd_out_cap}< <(
				{
					eval "exec ${fd_scope}>&1 1>&${fd_out}"
					cat <<< "${command}" \
						> "${SHWRAP_TMP_PATH}"/"${SHWRAP_ID}"_"${__shwrap_module_hash}"_run.sh
					env -i ${SHWRAP_MODULE_VERBOSE:+-v} \
						SHWRAP_MODULE_DEBUG="${SHWRAP_MODULE_DEBUG}" \
						SHWRAP_MODULE_LOG="${SHWRAP_MODULE_LOG}" \
						"${SHELL}" --noprofile --norc \
						"${SHWRAP_TMP_PATH}"/"${SHWRAP_ID}"_"${__shwrap_module_hash}"_run.sh "$@"
					eval "exec ${fd_scope}>&-"
				}
			)
			cat <&"${fd_out_cap}"
			exec {fd_out_cap}<&-
		)
		eval "$(cat <&"${fd_scope_cap}")"
		exec {fd_scope_cap}<&-
		eval "exec ${fd_out}>&-"
	}
	eval "exec {fd_scope}<&-"
	eval "exec {fd_out}<&-"
	unset '_shwrap_fds["${fd_scope}"]'
	unset '_shwrap_fds["${fd_out}"]'

	return "${__shwrap_ret}"
}

function __shwrap_cache()
{
	local __shwrap_module_path="$1"
	local scope="$2"

	local __shwrap_ret=1
	local command __shwrap_module_hash
	local fd_scope fd_scope_cap fd_out fd_out_cap
	__shwrap_module_hash="${_shwrap_modules_hashes[${__shwrap_module_path}]}"
	__shwrap_log "__shwrap_cache: cache '${__shwrap_module_path}' '${scope}'" >&2
	fd_scope=$(__shwrap_get_fd "${SHWRAP_FD_RANGE[@]}")
	eval "exec ${fd_scope}< /dev/null"
	_shwrap_fds["${fd_scope}"]="${fd_scope}"
	fd_out=$(__shwrap_get_fd "${SHWRAP_FD_RANGE[@]}")
	eval "exec ${fd_out}< /dev/null"
	_shwrap_fds["${fd_out}"]="${fd_out}"
	__shwrap_log "__shwrap__run: fds ${_shwrap_fds[*]}" >&2

	# shellcheck disable=SC2016
	# intentional use of single quotes to avoid unwanted expansions
	command='${SHWRAP_MODULE_DEBUG:+set -x}
		'"$(declare -p _shwrap_modules)"'
		'"$(declare -p _shwrap_modules_deps)"'
		'"$(declare -p _shwrap_modules_hashes)"'
		'"$(declare -p _shwrap_modules_names)"'
		'"$(declare -p _shwrap_modules_partials)"'
		'"$(declare -p _shwrap_modules_parts)"'
		'"$(declare -p _shwrap_modules_paths)"'
		'"$(declare -p _shwrap_scope)"'
		'"$(declare -p _shwrap_fds)"'
		'"$(declare -p _shwrap_modules_stack)"'
		eval "${_shwrap_scope[.]}"
		source '"${SHWRAP_MODULE}"'
		source '"${__shwrap_module_path}"'
		declare __shwrap_ret=$?
		_shwrap_modules+=(['"${__shwrap_module_hash}"']=$(declare -f))
		_shwrap_scope+=(['"${scope}"']=$(__shwrap_scope))
		{
			declare -p _shwrap_modules;
			declare -p _shwrap_modules_deps;
			declare -p _shwrap_modules_hashes;
			declare -p _shwrap_modules_names;
			declare -p _shwrap_modules_partials;
			declare -p _shwrap_modules_parts;
			declare -p _shwrap_modules_paths;
			declare -p _shwrap_scope;
			declare -p _shwrap_fds;
			declare -p _shwrap_modules_stack;
		} | __shwrap_declare >&'"${fd_scope}"'
		declare -p __shwrap_ret >&'"${fd_scope}"'
		exit ${__shwrap_ret}'
	{
		eval "exec ${fd_out}>&1"
		exec {fd_scope_cap}< <(
			exec {fd_out_cap}< <(
				{
					eval "exec ${fd_scope}>&1 1>&${fd_out}"
					cat <<< "${command}" \
						> "${SHWRAP_TMP_PATH}"/"${SHWRAP_ID}"_"${__shwrap_module_hash}"_cache.sh
					env -i ${SHWRAP_MODULE_VERBOSE:+-v} \
						SHWRAP_MODULE_DEBUG="${SHWRAP_MODULE_DEBUG}" \
						SHWRAP_MODULE_LOG="${SHWRAP_MODULE_LOG}" \
						"${SHELL}" --noprofile --norc \
						"${SHWRAP_TMP_PATH}"/"${SHWRAP_ID}"_"${__shwrap_module_hash}"_cache.sh
					eval "exec ${fd_out}>&-"
				}
			)
			cat <&"${fd_out_cap}"
			exec {fd_out_cap}<&-
		)
		eval "$(cat <&"${fd_scope_cap}")"
		exec {fd_scope_cap}<&-
		eval "exec ${fd_out}>&-"
	}
	eval "exec {fd_scope}<&-"
	eval "exec {fd_out}<&-"
	unset '_shwrap_fds["${fd_scope}"]'
	unset '_shwrap_fds["${fd_out}"]'

	return "${__shwrap_ret}"
}
