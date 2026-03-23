#!/usr/bin/env bats

setup() {
    source "${BATS_TEST_DIRNAME}/test_helper.bash"
    source "${PROJECT_ROOT}/scripts/helpers.sh"
}

teardown() {
    reset_tmux_mock
}

@test "get_tmux_option returns default when option is unset" {
    # Mock tmux to return empty string (unset option)
    mock_tmux_option "@cheatmux-key" ""
    result="$(get_tmux_option "@cheatmux-key" "?")"
    [ "$result" = "?" ]
}

@test "get_tmux_option returns custom value when option is set" {
    mock_tmux_option "@cheatmux-key" "F1"
    result="$(get_tmux_option "@cheatmux-key" "?")"
    [ "$result" = "F1" ]
}

@test "version_check passes when current >= required" {
    # Mock tmux -V to return "tmux 3.5"
    tmux() { echo "tmux 3.5"; }
    export -f tmux
    run version_check "3.2"
    [ "$status" -eq 0 ]
}

@test "version_check fails when current < required" {
    tmux() { echo "tmux 3.0"; }
    export -f tmux
    run version_check "3.2"
    [ "$status" -ne 0 ]
}

@test "version_check handles next-prefix versions" {
    tmux() { echo "tmux next-3.5"; }
    export -f tmux
    run version_check "3.2"
    [ "$status" -eq 0 ]
}
