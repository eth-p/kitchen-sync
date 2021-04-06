# ----------------------------------------------------------------------------------------------------------------------
# kitchen-sync | Copyright (C) 2018-2021 eth-p | MIT License
#
# Repository: https://github.com/eth-p/kitchen-sync
# Issues:     https://github.com/eth-p/kitchen-sync/issues
# ----------------------------------------------------------------------------------------------------------------------

# Gets the commit history hashes of a git repository.
#
# Arguments:
#     $1   -- The git repository.
#     $2   -- The starting hash. (optional)
#     $3   -- The ending hash. (optional)
#
# Hashes:
#     Specific: `6d98e3b7977ff40a353999d84297bbbf8cfe4319`
#     Oldest:   `<OLDEST>`
#     Newest:   `<NEWEST>`
#
repo_history() {
	local start=''
	local end=''
	local query=''
	
	case "$2" in
		"<OLDEST>") start='' ;;
		"<NEWEST>") start='HEAD' ;;
		*)          start="$2" ;;
	esac
	
	case "$3" in
		"<OLDEST>") end='' ;;
		"<NEWEST>") end='HEAD' ;;
		*)          end="$3" ;;
	esac
	
	if [[ -z "$start" && -n "$end" ]]; then
		query="$end"
	else
		query="${start}..${end}"	
	fi

	# Use git rev-list to find the commit hashes.	
	git -C "$1" rev-list "$query" || return $?
}

# Checks a commit to see if it was signed by a registered key.
# 
# Arguments:
#     $1   -- The git repository.
#     $2   -- The starting hash. (optional)
#     $3   -- The ending hash. (optional)
#
# Variables:
#     KTSYNC_TRUST_KEYS  -- The directory of the gnupg home containing the trusted signing keys.
#
repo_validate_commit() {
	GNUPGHOME="$KTSYNC_TRUST_KEYS" git -C "$1" verify-commit "$2" &>/dev/null || return "$?"
}
