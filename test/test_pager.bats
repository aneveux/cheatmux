#!/usr/bin/env bats

setup() {
    source "${BATS_TEST_DIRNAME}/test_helper.bash"
}

teardown() {
    reset_tmux_mock
}

@test "cheatmux.sh calls search_wrapper.sh" {
    grep -q "search_wrapper.sh" "${PROJECT_ROOT}/scripts/cheatmux.sh"
}

@test "search_wrapper.sh uses less -R flag for ANSI support" {
    grep -q "less.*-R" "${PROJECT_ROOT}/scripts/search_wrapper.sh"
}

@test "cheatmux.sh passes cheatsheet path to search_wrapper.sh" {
    # Path is now passed via CHEATMUX_SHEET_PATH env var
    grep -q 'CHEATMUX_SHEET_PATH' "${PROJECT_ROOT}/scripts/cheatmux.sh"
}

@test "render.sh output contains ANSI codes" {
    local output
    output=$("${PROJECT_ROOT}/scripts/render.sh" "${PROJECT_ROOT}/cheatsheet.md")

    # Check for ANSI escape sequence (either literal \033 or actual escape character)
    echo "$output" | grep -q $'\033\[' || echo "$output" | grep -q '\\033\['
}

