#!/bin/bash
# sh.wrap - module system for bash

# search.sh
# Module search functions.

# shellcheck source=src/common.sh
source "${SHWRAP_INIT_DIR}"/common.sh

function __shwrap_path()
{
	local __shwrap_module="$1"
	realpath -qsm "${__shwrap_module}"
}

function __shwrap_search()
{
	local __shwrap_module="$1"
	local __shwrap_module_hash __shwrap_module_name __shwrap_module_path
	local module_dir
	__shwrap_module_path=$(__shwrap_path "${__shwrap_module}")
	__shwrap_log "__shwrap_search: search '${__shwrap_module}'" >&2
	# check absolute path
	if [[ "${__shwrap_module}" == "${__shwrap_module_path}" ]]; then
		printf '%s' "${__shwrap_module_path}"
		return 0
	fi
	# check relative path
	if [[ "${#_shwrap_modules_stack[@]}" -gt 0 ]]; then
		__shwrap_module_hash="${_shwrap_modules_stack[-1]}"
		__shwrap_module_name="${_shwrap_modules_names[${__shwrap_module_hash}]}"
		__shwrap_module_path="${_shwrap_modules_paths[${__shwrap_module_name}]}"
		module_dir=$(dirname "${__shwrap_module_path}")
		if realpath -qse "${module_dir}"/"${__shwrap_module}"; then
			return 0
		fi
	fi
	if [[ "${__shwrap_module}" == "${__shwrap_module#./*}" ]] &&
		   [[ "${__shwrap_module}" == "${__shwrap_module#../*}" ]]; then
		# check user paths
		for module_dir in "${SHWRAP_MODULE_PATHS[@]}"; do
			local path="${module_dir}"/"${__shwrap_module}"
			if [[ "${module_dir}" == "${module_dir#/*}" ]]; then
				if [[ "${#_shwrap_modules_stack[@]}" -gt 0 ]]; then
					__shwrap_module_hash="${_shwrap_modules_stack[-1]}"
					__shwrap_module_name="${_shwrap_modules_names[${__shwrap_module_hash}]}"
					__shwrap_module_path="${_shwrap_modules_paths[${__shwrap_module_name}]}"
					path=$(dirname "${__shwrap_module_path}")/"${module_dir}"/"${__shwrap_module}"
				fi
			fi
			if realpath -qse "${path}"; then
				return 0
			fi
		done
		# check load paths
		if [[ "${#_shwrap_modules_stack[@]}" -gt 0 ]]; then
			local i stack=("${_shwrap_modules_stack[@]}")
			unset 'stack[-1]'
			for i in $(seq 0 "${#stack[@]}" | tac | tail +2); do
				__shwrap_module_hash="${stack[${i}]}"
				__shwrap_module_name="${_shwrap_modules_names[${__shwrap_module_hash}]}"
				__shwrap_module_path="${_shwrap_modules_paths[${__shwrap_module_name}]}"
				module_dir=$(dirname "${__shwrap_module_path}")
				if realpath -qse "${module_dir}"/"${__shwrap_module}"; then
					return 0
				fi
			done
		fi
		# default
		if [[ -v SHWRAP_MODULE_PATH ]]; then
			if realpath -qse "${SHWRAP_MODULE_PATH}"/"${__shwrap_module}"; then
				return 0
			fi
		fi
	fi
	# fallback
	__shwrap_path "${__shwrap_module}"
}
