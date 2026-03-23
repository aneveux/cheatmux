#!/usr/bin/env bash
#######################################
# search_wrapper.sh - Display cheatsheet in fzf viewer or less fallback
#
# Searches for fzf in common install locations (tmux popup uses minimal PATH)
# and displays the rendered cheatsheet in fzf with search capability.
# Falls back to less if fzf is not found.
#
# Globals:
#   CHEATMUX_SHEET_PATH - Cheatsheet file path (from cheatmux.sh)
#   CURRENT_DIR - Script directory (computed)
#
# Arguments:
#   $1 - Cheatsheet path (fallback if CHEATMUX_SHEET_PATH not set)
#
# Outputs:
#   Displays cheatsheet in fzf or less
#######################################

set -euo pipefail

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🚀  BOOTSTRAP
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=helpers.sh
source "$CURRENT_DIR/helpers.sh"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ⚙️  CONFIGURATION
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

cheatsheet_path="${CHEATMUX_SHEET_PATH:-${1:-}}"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🔍  FUNCTIONS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

#######################################
# Find fzf in common install locations.
#
# tmux run-shell/display-popup use minimal PATH, so check common locations.
#
# Arguments:
#   None
#
# Outputs:
#   Prints fzf binary path to stdout if found
#
# Returns:
#   0 and prints path if found, 1 otherwise
#######################################
find_fzf() {
	local fzf_path

	# Check PATH first
	if fzf_path=$(command -v fzf 2>/dev/null); then
		echo "$fzf_path"
		return 0
	fi

	# Check common install locations
	local dir
	for dir in "$HOME/bin" "$HOME/.fzf/bin" "$HOME/.local/bin" "/usr/local/bin"; do
		if [[ -x "$dir/fzf" ]]; then
			echo "$dir/fzf"
			return 0
		fi
	done

	return 1
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📋  MAIN LOGIC
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

fzf_bin=$(find_fzf) || fzf_bin=""

if [[ -n "$fzf_bin" ]]; then
	# Unset user's FZF_DEFAULT_OPTS to prevent interference with cheatmux display
	unset FZF_DEFAULT_OPTS

	"$CURRENT_DIR/render.sh" "$cheatsheet_path" |
		"$fzf_bin" --ansi --no-multi --reverse --prompt 'search: ' || true
else
	"$CURRENT_DIR/render.sh" "$cheatsheet_path" | less -R
fi
