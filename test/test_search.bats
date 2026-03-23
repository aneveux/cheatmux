#!/usr/bin/env bats

setup() {
    source "${BATS_TEST_DIRNAME}/test_helper.bash"
}

teardown() {
    reset_tmux_mock
}

@test "wrapper uses fzf when available" {
    grep -q "fzf.*--ansi" "${PROJECT_ROOT}/scripts/search_wrapper.sh"
}

@test "fzf prompt is minimal" {
    grep -q -- '--prompt.*search:' "${PROJECT_ROOT}/scripts/search_wrapper.sh"
    # Verify no header or preview flags
    ! grep -q -- '--header' "${PROJECT_ROOT}/scripts/search_wrapper.sh"
    ! grep -q -- '--preview' "${PROJECT_ROOT}/scripts/search_wrapper.sh"
}

@test "fzf default opts isolated" {
    grep -q "unset FZF_DEFAULT_OPTS" "${PROJECT_ROOT}/scripts/search_wrapper.sh"
}

@test "wrapper fallback without fzf" {
    # Check for fzf availability check
    grep -q "command -v fzf" "${PROJECT_ROOT}/scripts/search_wrapper.sh"
    # Check for less-only fallback path (no -X flag)
    grep -q "less -R" "${PROJECT_ROOT}/scripts/search_wrapper.sh"
}

@test "find_fzf checks common install paths" {
    # Check for common fzf installation paths
    grep -q '$HOME/bin' "${PROJECT_ROOT}/scripts/search_wrapper.sh"
    grep -q '$HOME/.fzf/bin' "${PROJECT_ROOT}/scripts/search_wrapper.sh"
    grep -q '$HOME/.local/bin' "${PROJECT_ROOT}/scripts/search_wrapper.sh"
    grep -q '/usr/local/bin' "${PROJECT_ROOT}/scripts/search_wrapper.sh"
}

@test "wrapper sources helpers" {
    grep -q "source.*helpers.sh" "${PROJECT_ROOT}/scripts/search_wrapper.sh"
}

@test "wrapper calls render" {
    grep -q "render.sh" "${PROJECT_ROOT}/scripts/search_wrapper.sh"
}
