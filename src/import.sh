#!/bin/bash
# sh.wrap - module system for bash

# import.sh
# Import related functions.

function __shwrap_partial_name()
{
	local __shwrap_parts=("$@")
	cat <(IFS=.; echo -n ."${__shwrap_parts[*]}")
}

function __shwrap_circular()
{
	local __shwrap_module_hash="$1"
	local i=0
	for i in "${!_shwrap_modules_stack[@]}"; do
		if [[ "${__shwrap_module_hash}" == "${_shwrap_modules_stack[${i}]}" ]]; then
			echo "${i}"
			return
		fi
	done
	echo -1
}

function __shwrap_hash()
{
	local __shwrap_module="$1"
	printf '%s' "${__shwrap_module}" | __shwrap_md5sum
}

function shwrap_import()
{
	local __shwrap_module="$1"
	shift

	local __shwrap_names=("$@")
	local __shwrap_module_hash __shwrap_module_path
	__shwrap_module_path=$(__shwrap_search "${__shwrap_module}")
	__shwrap_module_hash=$(__shwrap_hash "${__shwrap_module_path}")
	__shwrap_import "${__shwrap_module_path}" "${__shwrap_module_hash}" "${__shwrap_names[@]}"
}

function __shwrap_import()
{
	local __shwrap_module="$1"
	local __shwrap_scope="$2"
	shift 2

	local __shwrap_names=("$@")
	local __shwrap_caller
	if [[ "${#_shwrap_modules_stack[@]}" == 0 ]]; then
		__shwrap_caller=.
	else
		__shwrap_caller="${_shwrap_modules_stack[-1]}"
	fi
	__shwrap__import "${__shwrap_module}" "${__shwrap_scope}" "${__shwrap_caller}" "${__shwrap_names[@]}"
}

function __shwrap__import()
{
	local __shwrap_module="$1"
	local __shwrap_scope="$2"
	local __shwrap_caller="$3"
	shift 3

	local __shwrap_name __shwrap_names=("$@")
	local __shwrap_i
	local __shwrap_module_hash __shwrap_module_path __shwrap_partial __shwrap_partial_hash
	__shwrap_log "__shwrap__import: import '${__shwrap_module}' '${__shwrap_scope}' '${__shwrap_caller}'" >&2
	if [[ ! -v _shwrap_modules_partials["${__shwrap_module}"] ]]; then
		# import and cache partially imported modules
		__shwrap_module_path=$(__shwrap_search "${__shwrap_module}")
		__shwrap_module="${__shwrap_module_path}"
		__shwrap_module_hash=$(__shwrap_hash "${__shwrap_module_path}")
		_shwrap_modules_paths+=(["${__shwrap_module}"]="${__shwrap_module_path}")
		_shwrap_modules_hashes+=(["${__shwrap_module}"]="${__shwrap_module_hash}")
		_shwrap_modules_names+=(["${__shwrap_module_hash}"]="${__shwrap_module}")
		__shwrap_log "__shwrap__import: hash '${__shwrap_module}' '${__shwrap_module_hash}'" >&2
		if [[ "${#_shwrap_modules_stack[@]}" -gt 0 ]]; then
			if [[ "${_shwrap_modules_stack[-1]}" == "${__shwrap_module_hash}" ]]; then
				return 0
			fi
			__shwrap_partial=$(__shwrap_partial_name "${_shwrap_modules_stack[@]}")
			__shwrap_partial="${__shwrap_partial}"."${__shwrap_module_hash}"
			__shwrap_partial_hash=$(__shwrap_hash "${__shwrap_partial}")
			__shwrap_log "__shwrap__import: hash '${__shwrap_partial}' '${__shwrap_partial_hash}'" >&2
			if [[ ! -v _shwrap_modules["${__shwrap_partial_hash}"] ]]; then
				# create partial definitions and scope
				_shwrap_modules+=(["${__shwrap_partial_hash}"]=$(declare -f))
				_shwrap_modules_hashes+=(["${__shwrap_partial}"]="${__shwrap_partial_hash}")
				_shwrap_modules_names+=(["${__shwrap_partial_hash}"]="${__shwrap_partial}")
				_shwrap_modules_partials+=(["${__shwrap_partial}"]="")
				_shwrap_scope+=(["${_shwrap_modules_stack[-1]}"]=$(__shwrap_scope))
			fi
		fi
		__shwrap_i=$(__shwrap_circular "${__shwrap_module_hash}")
		if [[ "${__shwrap_i}" != -1 ]]; then
			# handle circular dependency
			if [[ "${_shwrap_modules[${__shwrap_module_hash}]}" == "###INITIALIZE MODULE###;" ]]; then
				local __shwrap_parts=("${_shwrap_modules_stack[@]:0:$((++__shwrap_i))}")
				local __shwrap_part __shwrap_dep="${_shwrap_modules_stack[${__shwrap_i}]}"
				__shwrap_part="$(__shwrap_partial_name "${__shwrap_parts[@]}")"."${__shwrap_dep}"
				if [[ $# == 0 ]]; then
					# shellcheck disable=SC2207
					# intentional use of word splitting
					__shwrap_names=($(__shwrap_run "${__shwrap_part}" 'declare -Fx' | cut -d $' ' -f3))
				fi
				for __shwrap_name in "${__shwrap_names[@]}"; do
					if __shwrap_run "${__shwrap_part}" '__shwrap_name_is_function '"${__shwrap_name}"; then
						__shwrap_log "__shwrap__import: import name '${__shwrap_part}' '${__shwrap_module}' '${__shwrap_name}'" >&2
						__shwrap_import "${__shwrap_part}" "${__shwrap_module_hash}" "${__shwrap_name}"
						_shwrap_modules_deps["${_shwrap_modules_stack[@]: -1}" "${__shwrap_module_hash}"]+="${__shwrap_name} "
						_shwrap_modules_parts["${_shwrap_modules_stack[@]: -1}" "${__shwrap_module_hash}"]="${__shwrap_part}"
					else
						__shwrap_log "__shwrap__import: error: '${__shwrap_name}' not imported from module '${__shwrap_module}'" >&2
					fi
				done
				return 0
			fi
		else
			_shwrap_modules_stack+=("${__shwrap_module_hash}")
		fi
	fi
	if [[ $# == 0 ]]; then
		# import module exports
		# cache module to avoid infinite recursion
		__shwrap__run "${__shwrap_module}" "${__shwrap_scope}" "###IMPORT###"
		# shellcheck disable=SC2207
		# intentional use of word splitting
		__shwrap_names=($(__shwrap_run "${__shwrap_module}" 'declare -Fx' | cut -d $' ' -f3))
		if [[ "${__shwrap_i}" == -1 ]]; then # prepare imports stack
			unset '_shwrap_modules_stack[-1]'
		fi
		if [[ -n "${__shwrap_names[*]}" ]]; then
			__shwrap_log "__shwrap__import: import names '${__shwrap_module}' '${__shwrap_scope}' '${__shwrap_names[*]}'" >&2
			__shwrap_import "${__shwrap_module}" "${__shwrap_scope}" "${__shwrap_names[@]}"
		fi
		if [[ "${__shwrap_i}" == -1 ]]; then # restore imports stack
			_shwrap_modules_stack+=("${__shwrap_module_hash}")
		fi
	else
		for __shwrap_name in "${__shwrap_names[@]}"; do
			if __shwrap_run "${__shwrap_module}" '__shwrap_name_is_function '"${__shwrap_name}"; then
				# wrap module name
				# shellcheck disable=SC1090
				# source from string
				source <(cat <<EOF
function ${__shwrap_name}() {
	# update caller scope before run
	_shwrap_scope+=([${__shwrap_caller}]=\$(__shwrap_scope))
	__shwrap__run "${__shwrap_module}" "${__shwrap_scope}" "${__shwrap_name}" "\$@"
	# apply caller scope after run
	eval "\${_shwrap_scope[${__shwrap_caller}]}"
}
EOF
						)
			else
				echo module: "'${__shwrap_name}' not imported from module '${__shwrap_module}'" >&2
			fi
		done
	fi
	if [[ "${__shwrap_i}" == -1 ]]; then
		# fix partially imported wrappers
		if [[ ! -v _shwrap_modules_partials["${__shwrap_module}"] ]]; then
			if [[ $# != 0 ]]; then
				local __shwrap_module_revdeps=()
				readarray -t -d $'\n' __shwrap_module_revdeps < <(printf '%s\n' "${!_shwrap_modules_deps[@]}" | grep "${__shwrap_module_hash}$")
				for __shwrap_module_revdep in "${__shwrap_module_revdeps[@]}"; do
					# shellcheck disable=SC2206
					# intentional use of word splitting
					local __shwrap_revdeps=(${__shwrap_module_revdep})
					# shellcheck disable=SC2086
					# intentional use of word splitting
					_shwrap_modules_deps["${__shwrap_revdeps[@]}"]=$(printf '%s\n' ${_shwrap_modules_deps["${__shwrap_revdeps[@]}"]} | sort | uniq | xargs)
					__shwrap_log "__shwrap__import: fix '${__shwrap_revdeps[*]}'" >&2
					if [[ "${__shwrap_module_hash}" == "${__shwrap_revdeps[1]}" ]]; then
						# shellcheck disable=SC2206
						# intentional use of word splitting
						__shwrap_names=(${_shwrap_modules_deps["${__shwrap_revdeps[@]}"]})
						_shwrap_modules_deps["${__shwrap_revdeps[@]}"]=""
						for __shwrap_name in "${__shwrap_names[@]}"; do
							__shwrap_partial="${_shwrap_modules_parts[${__shwrap_revdeps[@]}]}"-"${__shwrap_revdeps[0]}"
							__shwrap_partial_hash=$(__shwrap_hash "${__shwrap_partial}")
							_shwrap_modules+=(["${__shwrap_partial_hash}"]="${_shwrap_modules[${__shwrap_module_hash}]}")
							_shwrap_modules_hashes+=(["${__shwrap_partial}"]="${__shwrap_partial_hash}")
							_shwrap_modules_names+=(["${__shwrap_partial_hash}"]="${__shwrap_partial}")
							_shwrap_modules_partials+=(["${__shwrap_partial}"]="")
							# shellcheck disable=SC2016
							# intentional use of single quotes to avoid unwanted expansions
							local __shwrap_command='eval "$(__shwrap_run '"${_shwrap_modules_parts[${__shwrap_revdeps[@]}]}"' "declare -f '"${__shwrap_name}"'")"; declare -f'
							_shwrap_modules["${__shwrap_partial_hash}"]="$(__shwrap_run "${__shwrap_partial}" "${__shwrap_command}")"
							__shwrap_command="__shwrap__import '${__shwrap_partial}' '${__shwrap_module_hash}' '${__shwrap_revdeps[0]}' '${__shwrap_name}'; declare -f"
							_shwrap_modules+=(["${__shwrap_revdeps[0]}"]=$(__shwrap_run "${_shwrap_modules_names[${__shwrap_revdeps[0]}]}" "${__shwrap_command}"))
						done
					fi
				done
			fi
		fi
		unset '_shwrap_modules_stack[-1]'
		if [[ "${#_shwrap_modules_stack[@]}" -gt 0 ]]; then
			# apply scope changes after import
			eval "$(printf '%s' "${_shwrap_scope[${_shwrap_modules_stack[-1]}]}" | __shwrap_declare)"
		fi
	fi
}
