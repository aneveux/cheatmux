#!/usr/bin/env bats

setup() {
    source "${BATS_TEST_DIRNAME}/test_helper.bash"
}

@test "scripts/helpers.sh exists" {
    [ -f "${PROJECT_ROOT}/scripts/helpers.sh" ]
}

@test "scripts/helpers.sh is executable" {
    [ -x "${PROJECT_ROOT}/scripts/helpers.sh" ]
}

@test "cheatmux.tmux exists" {
    [ -f "${PROJECT_ROOT}/cheatmux.tmux" ]
}

@test "cheatmux.tmux is executable" {
    [ -x "${PROJECT_ROOT}/cheatmux.tmux" ]
}

@test "scripts/cheatmux.sh exists" {
    [ -f "${PROJECT_ROOT}/scripts/cheatmux.sh" ]
}

@test "scripts/cheatmux.sh is executable" {
    [ -x "${PROJECT_ROOT}/scripts/cheatmux.sh" ]
}

@test "cheatsheet.md exists" {
    [ -f "${PROJECT_ROOT}/cheatsheet.md" ]
}

@test "scripts/render.sh exists" {
    [ -f "${PROJECT_ROOT}/scripts/render.sh" ]
}

@test "scripts/render.sh is executable" {
    [ -x "${PROJECT_ROOT}/scripts/render.sh" ]
}

@test "LICENSE exists" {
    [ -f "${PROJECT_ROOT}/LICENSE" ]
}
