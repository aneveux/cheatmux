#######################################
# Shared test fixtures for cheatmux bats tests
#
# Provides utilities for test isolation, tmux mocking, and project
# root path resolution.
#
# Globals:
#   PROJECT_ROOT - Project root directory (exported for tests)
#######################################

# Project root (one level up from test/)
export PROJECT_ROOT
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

#######################################
# Mock tmux for unit tests that don't need a real tmux session.
#
# Arguments:
#   $1 - tmux option name (unused, for compatibility)
#   $2 - value to return from show-option
#
# Outputs:
#   None (defines shell function)
#
# Returns:
#   0 (always succeeds)
#######################################
mock_tmux_option() {
	local value="$2"
	# Create a mock tmux that returns the given value for show-option
	eval "tmux() {
		if [[ \"\$1\" == 'show-option' ]]; then
			echo \"$value\"
		elif [[ \"\$1\" == '-V' ]]; then
			echo 'tmux 3.5'
		fi
	}"
	export -f tmux
}

#######################################
# Reset tmux mock function.
#
# Arguments:
#   None
#
# Outputs:
#   None
#
# Returns:
#   0 (always succeeds)
#######################################
reset_tmux_mock() {
	unset -f tmux 2>/dev/null || true
}
