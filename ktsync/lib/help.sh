# ----------------------------------------------------------------------------------------------------------------------
# kitchen-sync | Copyright (C) 2018-2021 eth-p | MIT License
#
# Repository: https://github.com/eth-p/kitchen-sync
# Issues:     https://github.com/eth-p/kitchen-sync/issues
# ----------------------------------------------------------------------------------------------------------------------

# Sets the help from a heredoc.
#
# Example:
#     sethelp <<-'EOF'
#         Help text.
#     EOF
set_help() {
	read -r -d '' PROGRAM_HELP || true
}

# Prints the help and exits.
#
# Variable substitution:
#     "{{PROGRAM}}" -- $PROGRAM
#
# Section headings:
#     If a line starts with "[sh]", it will be considered a section heading.
show_help() {
	local helptext="$PROGRAM_HELP"
	
	# Replace variables.
	helptext="${helptext//\{\{PROGRAM\}\}/${PROGRAM}}" # "{{PROGRAM}}" with "${PROGRAM}"
	
	# Replace section headings.
	helptext="${helptext/#\[hh\]/$(printc "%{B}%{REVERSE}")HELP: }"   # "[hh]"
	helptext="${helptext//$'\n'\[sh\]/$'\n'$(printc "%{B}")}"   # "[sh]"
	helptext="${helptext//$'\n'/$(printc "%{CLEAR}")$'\n'}"     # Clear the color after every line.
	
	# Print the help.
	printc "$helptext"
	exit 1
}

# ----------------------------------------------------------------------------------------------------------------------
# Option Parser Hook:
# ----------------------------------------------------------------------------------------------------------------------
SHIFTOPT_HOOKS+=("__shiftopt_hook__help")

# Option parser hook: --help support.
# This will accept `-h`, `-?`, or `--help`, which prints the usage information and exits.
__shiftopt_hook__help() {
	if [[ "$OPT" = "--help" ]] || [[ "$OPT" = "-h" ]] || [[ "$OPT" = "-?" ]]; then
		show_help
	fi

	return 1
}
