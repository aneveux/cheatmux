#!/usr/bin/env bats

setup() {
    source "${BATS_TEST_DIRNAME}/test_helper.bash"
    source "${PROJECT_ROOT}/scripts/helpers.sh"
}

teardown() {
    reset_tmux_mock
}

@test "default keybinding is ? when @cheatmux-key unset" {
    mock_tmux_option "@cheatmux-key" ""
    result="$(get_tmux_option "@cheatmux-key" "?")"
    [ "$result" = "?" ]
}

@test "custom keybinding is read from @cheatmux-key" {
    mock_tmux_option "@cheatmux-key" "C-h"
    result="$(get_tmux_option "@cheatmux-key" "?")"
    [ "$result" = "C-h" ]
}

@test "cheatmux.sh invokes display-popup" {
    grep -q 'display-popup' "${PROJECT_ROOT}/scripts/cheatmux.sh"
}
