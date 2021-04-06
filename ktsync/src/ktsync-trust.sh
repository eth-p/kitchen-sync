#!/usr/bin/env bash
# ----------------------------------------------------------------------------------------------------------------------
# kitchen-sync | Copyright (C) 2018-2021 eth-p | MIT License
#
# Repository: https://github.com/eth-p/kitchen-sync
# Issues:     https://github.com/eth-p/kitchen-sync/issues
#
# This command (`ktsync trust`) will allow for changes to the commit signing trusted key store.
# ----------------------------------------------------------------------------------------------------------------------
[[ "${#BASH_SOURCE[@]}" -gt 1 ]] || { echo "Do not run $(basename -- "$0") directly."; exit 1; }
# ----------------------------------------------------------------------------------------------------------------------
# Documentation:
# ----------------------------------------------------------------------------------------------------------------------
set_help <<-'EOF'
	[hh]{{PROGRAM}}
	
	[sh]DESCRIPTION:
	    View or changes the contents of the commit signing trusted key store.
	
	[sh]SYNOPSIS:
	    %{CMD}{{PROGRAM}}%{ARG} --list%{HELP}              -- Show a list of trusted keys.
	    %{CMD}{{PROGRAM}}%{ARG} --trust [file]%{HELP}      -- Trust a key.
	    %{CMD}{{PROGRAM}}%{ARG} --trust-all [dir]%{HELP}   -- Trust all keys in a directory.
	    %{CMD}{{PROGRAM}}%{ARG} --untrust [id]%{HELP}      -- Un-trust a key.
EOF
# ----------------------------------------------------------------------------------------------------------------------
# Options:
# ----------------------------------------------------------------------------------------------------------------------
ACTION='help'
ARGS=()

while shiftopt; do case "$OPT" in
	--list)      ACTION="list" ;;
	--trust)     ACTION="trust" ;;
	--trust-all) ACTION="trust_all" ;;
	--untrust)   ACTION="untrust" ;;
	--gpgcmd)    ACTION="gpgcmd"; getargs ARGS; break ;;

	# Unknown option:
	-*) print_fatal "unknown option '%s'" "$OPT" ;;
	*)  print_fatal "unknown argument '%s'" "$OPT" ;;
esac; done

# ----------------------------------------------------------------------------------------------------------------------
# Main:
# ----------------------------------------------------------------------------------------------------------------------
action_help() {
	show_help
}

action_list() {
	trust_init
	
	local keys=0
	local key
	local user
	while IFS=':' read -r key user; do
		if [[ "$keys" -eq 0 ]]; then
			printc "%{HEADER}Keys:%{CLEAR}\n"
		fi
		
		((keys++)) || true
		printc "%{KEY}%s - %{NOTE}%s%{CLEAR}\n" "$key" "$user"
	done < <(trust_key_list)
}

action_trust() {
	trust_key_generate
}

action_trust_all() {
	:
}

action_untrust() {
	:
}

action_gpgcmd() {
	ktsync_gpg "$@"
}

"action_${ACTION}" "${ARGS[@]}" || exit $?
