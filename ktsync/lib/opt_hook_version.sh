# ----------------------------------------------------------------------------------------------------------------------
# kitchen-sync | Copyright (C) 2018-2021 eth-p | MIT License
#
# Repository: https://github.com/eth-p/kitchen-sync
# Issues:     https://github.com/eth-p/kitchen-sync/issues
# ----------------------------------------------------------------------------------------------------------------------

SHIFTOPT_HOOKS+=("__shiftopt_hook__version")

# Option parser hook: --version support.
# This will accept `-V` or `--version`, which prints the version information and exits.
__shiftopt_hook__version() {
	if [[ "$OPT" = "--version" ]] || [[ "$OPT" = "-V" ]]; then
		printc "%s %s\n\n%s\n%s\n" "${PROGRAM}" "${PROGRAM_VERSION}" \
			"Copyright (C) 2018-2021 eth-p | MIT License" \
			"https://github.com/eth-p/kitchen-sync"
		exit 0
	fi

	return 1
}
