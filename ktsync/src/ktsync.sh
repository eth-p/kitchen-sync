#!/usr/bin/env bash
# ----------------------------------------------------------------------------------------------------------------------
# kitchen-sync | Copyright (C) 2018-2021 eth-p | MIT License
#
# Repository: https://github.com/eth-p/kitchen-sync
# Issues:     https://github.com/eth-p/kitchen-sync/issues
#
# This command (`ktsync`) is the executable script for all of the ktsync tool.
# It will parse common command line options and run one of the subcommands.
# ----------------------------------------------------------------------------------------------------------------------
# shellcheck disable=SC2034
set -e
KTSYNC_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd "$(dirname "$(readlink "${BASH_SOURCE[0]}" || echo ".")")/.." && pwd)"
KTSYNC_COMMANDS="${KTSYNC_ROOT}/src"
KTSYNC_LIB="${KTSYNC_ROOT}/lib"
# ----------------------------------------------------------------------------------------------------------------------
# Initialize:
# ----------------------------------------------------------------------------------------------------------------------
KTSYNC_NAME="ktsync"                                                    # A variable for changing the config directory.
KTSYNC_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/${KTSYNC_NAME}"        # Directory for configuration.
KTSYNC_TRUST_KEYS="${KTSYNC_CONFIG}/.trust/gpg"                         # Directory for trusted GPG keys.
KTSYNC_TRUST_BINS="${KTSYNC_CONFIG}/.trust/bin"                         # Directory for trusted 'ktsync' scripts.
KTSYNC_DIR="$(dirname -- "${KTSYNC_ROOT}")"                             # Directory of the repo to copy configs from.
# ----------------------------------------------------------------------------------------------------------------------
# Libraries:
# ----------------------------------------------------------------------------------------------------------------------
source "${KTSYNC_LIB}/opt.sh"
source "${KTSYNC_LIB}/opt_hook_version.sh"
source "${KTSYNC_LIB}/help.sh"
source "${KTSYNC_LIB}/print.sh"
source "${KTSYNC_LIB}/print_util.sh"
source "${KTSYNC_LIB}/trust.sh"
source "${KTSYNC_LIB}/repo.sh"
source "${KTSYNC_LIB}/gpg.sh"
# ----------------------------------------------------------------------------------------------------------------------
# Documentation:
# ----------------------------------------------------------------------------------------------------------------------
PROGRAM="$(basename -- "$0" ".sh")"
PROGRAM_VERSION="0.1.0"
set_help <<-'EOF'
	Help docs here.
	
	TODO help stuff.
EOF
# ----------------------------------------------------------------------------------------------------------------------
# Options:
# ----------------------------------------------------------------------------------------------------------------------
SUBCOMMAND=""
while shiftopt; do case "$OPT" in
	--repo) shiftval; KTSYNC_DIR="${OPT_VAL}" ;;
	
	# Unknown option:
	-*) print_fatal "unknown option '%s'" "$OPT" ;;

	# Positional arguments are subcommands:
	*) SUBCOMMAND="$OPT"; getargs SUBCOMMAND_ARGS; break ;;
esac; done
# ----------------------------------------------------------------------------------------------------------------------
# Main:
# ----------------------------------------------------------------------------------------------------------------------
# If no subcommand is provided, show the help and exit.
if [[ "$SUBCOMMAND" = "" ]]; then
	show_help
fi

# If git and gpg are not installed, show an error and exit.
# TODO: This check.

# If the repository doesn't exist (or is not actually a repo), show an error and exit.
if ! [[ -d "${KTSYNC_DIR}" ]] || ! [[ -e "${KTSYNC_DIR}/.git" ]]; then
	print_fatal "'%s' is not a git repository" "$KTSYNC_DIR"
fi

# If the subcommand doesn't exist (or contains a /), show an error and exit.
if [[ "${SUBCOMMAND}" = */* ]] || ! [[ -f "${KTSYNC_COMMANDS}/ktsync-${SUBCOMMAND}.sh" ]]; then
	print_fatal "unknown subcommand '%s'" "$SUBCOMMAND"
fi

# Source the subcommand.
PROGRAM="${PROGRAM} ${SUBCOMMAND}"
setargs "${SUBCOMMAND_ARGS[@]}"
source "${KTSYNC_COMMANDS}/ktsync-${SUBCOMMAND}.sh"
