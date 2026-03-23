#!/usr/bin/env bash
#######################################
# cheatmux - Display formatted tmux cheatsheet in popup
#
# Main entry point for cheatmux plugin. Resolves the cheatsheet file path
# with priority order (tmux option > XDG config > plugin default) and launches
# the cheatsheet in a tmux popup using fzf search or less fallback.
#
# Globals:
#   CURRENT_DIR - Script directory (computed)
#   CHEATMUX_SHEET_PATH - Exported cheatsheet path for search_wrapper.sh
#
# Arguments:
#   None (uses tmux options)
#
# Outputs:
#   Displays formatted cheatsheet in tmux popup
#######################################

set -euo pipefail

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🚀  BOOTSTRAP
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=helpers.sh
source "$CURRENT_DIR/helpers.sh"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📋  MAIN LOGIC
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

tmux_option=$(get_tmux_option "@cheatmux-path" "")
cheatsheet_path=$(resolve_cheatsheet_path "$tmux_option" "$CURRENT_DIR/../cheatsheet.md")

# Export path to avoid injection via interpolation
export CHEATMUX_SHEET_PATH="$cheatsheet_path"

tmux display-popup -E -T "Cheatmux" -w 80% -h 80% \
	"$CURRENT_DIR/search_wrapper.sh" "$cheatsheet_path"
