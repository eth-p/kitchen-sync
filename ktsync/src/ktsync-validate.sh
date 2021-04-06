#!/usr/bin/env bash
# ----------------------------------------------------------------------------------------------------------------------
# kitchen-sync | Copyright (C) 2018-2021 eth-p | MIT License
#
# Repository: https://github.com/eth-p/kitchen-sync
# Issues:     https://github.com/eth-p/kitchen-sync/issues
#
# This command (`ktsync validate`) will check the history of the git repository, making sure that none of the commits
# are unsigned or signed by an unregistered GPG key. This verification allows ktsync to determine if the repo was
# tampered with.
# ----------------------------------------------------------------------------------------------------------------------
[[ "${#BASH_SOURCE[@]}" -gt 1 ]] || { echo "Do not run $(basename -- "$0") directly."; exit 1; }
# ----------------------------------------------------------------------------------------------------------------------
# Documentation:
# ----------------------------------------------------------------------------------------------------------------------
sethelp <<-'EOF'
	Help docs here.
	
	TODO help stuff.
EOF
# ----------------------------------------------------------------------------------------------------------------------
# Options:
# ----------------------------------------------------------------------------------------------------------------------
while shiftopt; do case "$OPT" in
	# Unknown option:
	-*) print_fatal "unknown option '%s'" "$OPT" ;;
	*)  print_fatal "unknown argument '%s'" "$OPT" ;;
esac; done

# ----------------------------------------------------------------------------------------------------------------------
# Main:
# ----------------------------------------------------------------------------------------------------------------------
while read -r commit; do
	echo "$commit"
done < <(repo_history "${KTSYNC_DIR}" '<OLDEST>' '<NEWEST>')
echo "Good!"
