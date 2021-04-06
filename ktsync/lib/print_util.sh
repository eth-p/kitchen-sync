# ----------------------------------------------------------------------------------------------------------------------
# kitchen-sync | Copyright (C) 2018-2021 eth-p | MIT License
#
# Repository: https://github.com/eth-p/kitchen-sync
# Issues:     https://github.com/eth-p/kitchen-sync/issues
# ----------------------------------------------------------------------------------------------------------------------

# Print a warning message to stderr.
# Arguments:
#     1   -- The printc formatting string.
#     ... -- The printc formatting arguments.
print_warning() {
	printc "%{WARNING}[%s warning]%{CLEAR}: $1%{CLEAR}\n" "$PROGRAM" "${@:2}" 1>&2
}

# Print an error message to stderr.
# Arguments:
#     1   -- The printc formatting string.
#     ... -- The printc formatting arguments.
print_error() {
	printc "%{ERROR}[%s error]%{CLEAR}: $1%{CLEAR}\n" "$PROGRAM" "${@:2}" 1>&2
}

# Print an error message to stderr and then exits.
# Arguments:
#     1   -- The printc formatting string.
#     ... -- The printc formatting arguments.
print_fatal() {
	printc "%{ERROR}[%s error]%{CLEAR}: $1%{CLEAR}\n" "$PROGRAM" "${@:2}" 1>&2
	exit 1
}
