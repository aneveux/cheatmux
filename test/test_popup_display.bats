#!/usr/bin/env bats

setup() {
    source "${BATS_TEST_DIRNAME}/test_helper.bash"
}

teardown() {
    reset_tmux_mock
}

@test "cheatmux.sh contains display-popup command" {
    grep -q "display-popup" "${PROJECT_ROOT}/scripts/cheatmux.sh"
}

@test "cheatmux.sh contains 80% width and height flags" {
    grep -q "\-w 80%" "${PROJECT_ROOT}/scripts/cheatmux.sh"
    grep -q "\-h 80%" "${PROJECT_ROOT}/scripts/cheatmux.sh"
}

@test "cheatmux.sh contains -E flag for auto-close" {
    grep -q "\-E" "${PROJECT_ROOT}/scripts/cheatmux.sh"
}

@test "cheatmux.sh contains -T flag with Cheatmux title" {
    grep -q '\-T "Cheatmux"' "${PROJECT_ROOT}/scripts/cheatmux.sh" || \
    grep -q "\-T 'Cheatmux'" "${PROJECT_ROOT}/scripts/cheatmux.sh"
}

@test "cheatmux.sh sources helpers.sh" {
    grep -q 'source.*helpers\.sh' "${PROJECT_ROOT}/scripts/cheatmux.sh"
}

@test "cheatmux.sh references search_wrapper.sh in display-popup command" {
    grep -q 'search_wrapper\.sh' "${PROJECT_ROOT}/scripts/cheatmux.sh"
}
