#!/usr/bin/env bash
#######################################
# Cheatsheet ANSI color renderer
#
# Parses cheatsheet markdown and outputs colored text for terminal display.
# Section headers (## Header) are rendered in cyan, shortcut entries
# (prefix + key    Description) are rendered with green keys.
#
# Globals:
#   None
#
# Arguments:
#   $1 - Path to cheatsheet markdown file
#
# Outputs:
#   Writes ANSI-colored cheatsheet to stdout
#   Writes error messages to stderr on failure
#######################################

set -euo pipefail

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🎨  CONSTANTS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ANSI color constants
readonly CYAN="\033[1;36m"
readonly GREEN="\033[1;32m"
readonly RESET="\033[0m"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📄  RENDERING FUNCTIONS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

#######################################
# Parse and colorize cheatsheet file content.
#
# Internal helper that processes each line of the cheatsheet and applies
# ANSI color codes for section headers and shortcut entries.
#
# Arguments:
#   $1 - Path to cheatsheet file
#
# Outputs:
#   Writes ANSI-colored lines to stdout
#
# Returns:
#   0 on success
#######################################
_parse_cheatsheet_file() {
	local cheatsheet_file="$1"

	while IFS= read -r line; do
		# Section headers: ## Section Name
		if [[ "$line" =~ ^##[[:space:]](.+)$ ]]; then
			printf '%b%s%b\n' "$CYAN" "## ${BASH_REMATCH[1]}" "$RESET"

		# Comment lines: lines starting with # (but not ##) - skip
		elif [[ "$line" =~ ^# ]]; then
			continue

		# Shortcut lines: prefix + key    Description
		# Pattern: captures "prefix + key" as group 1, description as group 2
		elif [[ "$line" =~ ^([^[:space:]]+[[:space:]]+\+[[:space:]]+[^[:space:]]+)[[:space:]]+(.+)$ ]]; then
			printf '%b%s%b    %s\n' "$GREEN" "${BASH_REMATCH[1]}" "$RESET" "${BASH_REMATCH[2]}"

		# Blank lines: preserve for spacing
		elif [[ "$line" =~ ^[[:space:]]*$ ]]; then
			printf '\n'

		# Default: pass through unmodified
		else
			printf '%s\n' "$line"
		fi
	done <"$cheatsheet_file"
}

#######################################
# Render cheatsheet with ANSI color formatting.
#
# Validates cheatsheet file exists and is readable, then parses and renders
# it with color highlighting for section headers and shortcut entries.
#
# Arguments:
#   $1 - Path to cheatsheet file
#
# Outputs:
#   Writes ANSI-colored cheatsheet to stdout
#   Writes error messages to stderr on failure
#
# Returns:
#   0 on success
#   1 if file missing, unreadable, or argument not provided
#######################################
render_cheatsheet() {
	local cheatsheet_file="$1"

	# Error handling: check file argument provided
	if [[ -z "$cheatsheet_file" ]]; then
		printf '%s\n' "Error: Cheatsheet file path not provided" >&2
		printf '%s\n' "" >&2
		printf '%s\n' "Usage: render.sh <cheatsheet-file>" >&2
		return 1
	fi

	# Error handling: check file exists
	if [[ ! -f "$cheatsheet_file" ]]; then
		printf '%s\n' "Error: Cheatsheet file not found: $cheatsheet_file" >&2
		printf '%s\n' "" >&2
		printf '%s\n' "To customize, either:" >&2
		printf '%s\n' "  1. Create: ~/.config/cheatmux/cheatsheet.md" >&2
		printf '%s\n' "  2. Set custom path: tmux set -g @cheatmux-path /path/to/cheatsheet.md" >&2
		return 1
	fi

	# Error handling: check file is readable
	if [[ ! -r "$cheatsheet_file" ]]; then
		printf '%s\n' "Error: Cannot read cheatsheet file: $cheatsheet_file" >&2
		return 1
	fi

	# Check if file is empty or contains only comments/blank lines
	if ! grep -qE '^(##[[:space:]]|[^#[:space:]])' "$cheatsheet_file"; then
		printf '%s\n' "Cheatsheet is empty. Add shortcuts to your cheatsheet file."
		return 0
	fi

	# Parse and render cheatsheet with ANSI colors
	_parse_cheatsheet_file "$cheatsheet_file"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🚀  MAIN
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

#######################################
# Main entry point.
#
# Arguments:
#   $@ - All command line arguments
#
# Returns:
#   Exit code from render_cheatsheet
#######################################
main() {
	render_cheatsheet "$@"
}

main "$@"
