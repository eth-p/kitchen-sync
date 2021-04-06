# ----------------------------------------------------------------------------------------------------------------------
# kitchen-sync | Copyright (C) 2018-2021 eth-p | MIT License
#
# Repository: https://github.com/eth-p/kitchen-sync
# Issues:     https://github.com/eth-p/kitchen-sync/issues
# ----------------------------------------------------------------------------------------------------------------------
KTSYNC_GPG=gpg

ktsync_gpg() {
	LC_CTYPE=en_US GNUPGHOME="$KTSYNC_TRUST_KEYS" "$KTSYNC_GPG" \
		--no-default-keyring \
		--keyring="${KTSYNC_TRUST_KEYS}/keys.pub" \
		--secret-keyring="${KTSYNC_TRUST_KEYS}/keys.sec" \
		"$@"
}
