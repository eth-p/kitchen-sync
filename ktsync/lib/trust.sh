# ----------------------------------------------------------------------------------------------------------------------
# kitchen-sync | Copyright (C) 2018-2021 eth-p | MIT License
#
# Repository: https://github.com/eth-p/kitchen-sync
# Issues:     https://github.com/eth-p/kitchen-sync/issues
# ----------------------------------------------------------------------------------------------------------------------
KTSYNC_TRUST_GEN_ALGORITHM=''

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
trust_init() {
	# Create the keys directory.
	if ! [[ -e "$KTSYNC_TRUST_KEYS" ]]; then
		mkdir -p "$KTSYNC_TRUST_KEYS"
	fi

	# Ensure the directory is 700.
	chmod -R 700 "$KTSYNC_TRUST_KEYS"
}

# Generates a new GPG key.
#
# Arguments:
#     $1   -- The key name. (optional)
#     $2   -- The key email. (optional)
#     $3   -- The key comment. (optional)
#
# Variables:
#     KTSYNC_TRUST_KEYS  -- The directory of the gnupg home containing the trusted signing keys.
#
trust_key_generate() {
	local key_name="$1"
	local key_email="$2"
	local key_comment="$3"

	# Use git for default name and email.
	[[ -n "$key_name" ]] || key_name="$(git config --get user.name || true)"
	[[ -n "$key_email" ]] || key_email="$(git config --get user.email || true)"

	# Use system for defaults.
	[[ -n "$key_comment" ]] || key_comment="$(hostname)"
	[[ -n "$key_name" ]]    || key_name="$(whoami)"
	[[ -n "$key_email" ]]   || key_email="${key_name}@$(hostname)"

	# Read the output
	local line
	local output=''
	while read -r line; do
		output="${output}"$'\n'"${line}"
		if [[ "$line" =~ key[[:space:]]([0-9A-F]+)[[:space:]]marked ]]; then
			echo "${BASH_REMATCH[1]}"
			return 0
		fi
	done < <({
		ktsync_gpg --batch --generate-key 2>&1 <<- EOF
			Key-Type: eddsa
			Key-Curve: ed25519
			Subkey-Type: default
			Name-Real: ${key_name}
			Name-Comment: ${key_comment}
			Name-Email: ${key_email}
			Expire-Date: 0
			%no-ask-passphrase
			%no-protection
			%commit
		EOF
	})
	
	echo "$output" 1>&2
	return 1
}

trust_key_list() {
	local f_type
	local f_9
	local f_10
	local _
	
	local print="false"
	local user
	local key
	while IFS=':' read -r f_type _ _ _ _ _ _ _ _ f_10 _; do
		case "$f_type" in
			uid) user="$f_10"; print=true ;;
			fpr) key="$f_10" ;;
		esac
		
		if [[ "$print" = "true" ]]; then
			print=false
			echo "${key}:${user}"
		fi
	done < <(ktsync_gpg --list-keys --with-colons)
}

trust_key_add() {
	:
}

trust_key_remove() {
	:
}
