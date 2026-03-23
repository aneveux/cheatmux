#!/usr/bin/env bash
# cheatmux - TPM entry point
# Registers configurable keybinding for cheatsheet popup

set -euo pipefail

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/helpers.sh
source "${CURRENT_DIR}/scripts/helpers.sh"

#######################################
# Register tmux keybinding for cheatsheet popup.
#
# Globals:
#   CURRENT_DIR - Plugin installation directory
#
# Arguments:
#   None
#
# Outputs:
#   Displays tmux message if version check fails
#
# Returns:
#   0 on success, 1 if tmux version check fails
#######################################
main() {
	if ! version_check "3.2"; then
		tmux display-message "cheatmux requires tmux 3.2+ (current: $(tmux -V))"
		return 1
	fi

	local key
	key="$(get_tmux_option "@cheatmux-key" "?")"

	tmux bind-key "$key" run-shell "${CURRENT_DIR}/scripts/cheatmux.sh"
}

main
