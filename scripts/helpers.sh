#######################################
# Shared helper functions for cheatmux plugin
#
# Provides utilities for tmux option reading, version checking, and
# cheatsheet path resolution with XDG directory fallback support.
#
# Sourced by cheatmux.tmux and all scripts that need shared functionality.
#
# Globals:
#   CHEATMUX_HELPERS_LOADED - Guard variable for idempotent sourcing
#
# Dependencies:
#   - tmux (for option reading and version check)
#######################################

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🔒  GUARD
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[[ -n "${CHEATMUX_HELPERS_LOADED:-}" ]] && return 0
CHEATMUX_HELPERS_LOADED=1

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🛠️  UTILITY FUNCTIONS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

#######################################
# Get tmux option value or return default.
#
# Arguments:
#   $1 - tmux option name
#   $2 - default value if option not set
#
# Outputs:
#   Prints option value or default to stdout
#
# Returns:
#   0 (always succeeds)
#######################################
get_tmux_option() {
	local option="$1"
	local default_value="$2"
	local option_value

	option_value=$(tmux show-option -gqv "$option")
	if [[ -z "$option_value" ]]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

#######################################
# Check if current tmux version meets minimum requirement.
#
# Arguments:
#   $1 - required version (e.g., "3.2")
#
# Outputs:
#   None (uses grep -q for silent check)
#
# Returns:
#   0 if current >= required, 1 otherwise
#######################################
version_check() {
	local required="$1"
	local current
	current="$(tmux -V | cut -d' ' -f2)"

	# If required version sorts first (or equal), current >= required
	printf '%s\n%s\n' "$required" "$current" | sort -V | head -n1 | grep -q "^${required}$"
}

#######################################
# Resolve cheatsheet file path with fallback priority.
#
# Priority: tmux option > XDG config > ~/.config > XDG data > ~/.local/share > plugin default
#
# Arguments:
#   $1 - tmux option value (may be empty)
#   $2 - plugin default path (fallback)
#
# Outputs:
#   Prints resolved cheatsheet file path to stdout
#
# Returns:
#   0 (always succeeds, uses plugin default as final fallback)
#######################################
resolve_cheatsheet_path() {
	local tmux_option_value="$1"
	local plugin_default="$2"

	# Priority 1: @cheatmux-path option (with tilde expansion)
	if [[ -n "$tmux_option_value" ]]; then
		local expanded="${tmux_option_value/#\~/"$HOME"}"
		if [[ -f "$expanded" ]]; then
			echo "$expanded"
			return 0
		fi
	fi

	# Priority 2: $XDG_CONFIG_HOME/cheatmux/cheatsheet.md
	if [[ -n "${XDG_CONFIG_HOME:-}" ]]; then
		local xdg_path="$XDG_CONFIG_HOME/cheatmux/cheatsheet.md"
		if [[ -f "$xdg_path" ]]; then
			echo "$xdg_path"
			return 0
		fi
	fi

	# Priority 3: ~/.config/cheatmux/cheatsheet.md
	local default_config="$HOME/.config/cheatmux/cheatsheet.md"
	if [[ -f "$default_config" ]]; then
		echo "$default_config"
		return 0
	fi

	# Priority 4: $XDG_DATA_HOME/cheatmux/cheatsheet.md
	if [[ -n "${XDG_DATA_HOME:-}" ]]; then
		local xdg_data_path="$XDG_DATA_HOME/cheatmux/cheatsheet.md"
		if [[ -f "$xdg_data_path" ]]; then
			echo "$xdg_data_path"
			return 0
		fi
	fi

	# Priority 5: ~/.local/share/cheatmux/cheatsheet.md
	local default_data="$HOME/.local/share/cheatmux/cheatsheet.md"
	if [[ -f "$default_data" ]]; then
		echo "$default_data"
		return 0
	fi

	# Priority 6: Plugin bundled default (always exists)
	echo "$plugin_default"
	return 0
}
