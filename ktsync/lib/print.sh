# ----------------------------------------------------------------------------------------------------------------------
# kitchen-sync | Copyright (C) 2018-2021 eth-p | MIT License
#
# Repository: https://github.com/eth-p/kitchen-sync
# Issues:     https://github.com/eth-p/kitchen-sync/issues
# ----------------------------------------------------------------------------------------------------------------------

# Printf, but with optional colors.
# This uses the same syntax and arguments as printf.
#
# Example:
#     printc "%{RED}This is red %s.%{CLEAR}\n" "text"
#
printc() {
	printf "$(sed "$_PRINTC_PATTERN" <<<"$1")" "${@:2}"
}

# Initializes the color tags for printc.
#
# Arguments:
#     true  -- Turns on color output.
#     false -- Turns off color output.
printc_init() {
	case "$1" in
	true)  _PRINTC_PATTERN="$_PRINTC_PATTERN_ANSI" ;;
	false) _PRINTC_PATTERN="$_PRINTC_PATTERN_PLAIN" ;;

	"[DEFINE]") {
		_PRINTC_PATTERN_ANSI=""
		_PRINTC_PATTERN_PLAIN=""

		local name
		local ansi
		while read -r name ansi; do
			if [[ -z "${name}" && -z "${ansi}" ]] || [[ "${name:0:1}" = "#" ]]; then
				continue
			fi

			ansi="${ansi/\\/\\\\}"

			_PRINTC_PATTERN_PLAIN="${_PRINTC_PATTERN_PLAIN}s/%{${name}}//g;"
			_PRINTC_PATTERN_ANSI="${_PRINTC_PATTERN_ANSI}s/%{${name}}/${ansi}/g;"
		done

		if [[ -t 1 && -z "${NO_COLOR+x}" ]]; then
			_PRINTC_PATTERN="$_PRINTC_PATTERN_ANSI"
		else
			_PRINTC_PATTERN="$_PRINTC_PATTERN_PLAIN"
		fi
	} ;;
	esac
}

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

# ----------------------------------------------------------------------------------------------------------------------
# Initialization:
# ----------------------------------------------------------------------------------------------------------------------
printc_init "[DEFINE]" <<END
	CLEAR	\x1B[m
	REVERSE \x1B[7m
	
	ERROR   \x1B[31m
	WARNING \x1B[33m
	HEADER  \x1B[35m
	
	# Keys
	KEY     \x1B[34m
	NOTE    \x1B[39m
	
	# Helptext Formats
	CMD     \x1B[2;35m
	ARG     \x1B[;35m
	HELP    \x1B[m
	B       \x1B[1m
END
