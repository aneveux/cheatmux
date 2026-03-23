#!/usr/bin/env bats

setup() {
    source "${BATS_TEST_DIRNAME}/test_helper.bash"
}

teardown() {
    reset_tmux_mock
}

@test "cheatmux.tmux file exists at repo root" {
    [ -f "${PROJECT_ROOT}/cheatmux.tmux" ]
}

@test "cheatmux.tmux has correct shebang" {
    head -1 "${PROJECT_ROOT}/cheatmux.tmux" | grep -q "#!/usr/bin/env bash"
}

@test "cheatmux.tmux sets CURRENT_DIR" {
    grep -q 'CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE\[0\]}")" && pwd)"' "${PROJECT_ROOT}/cheatmux.tmux"
}

@test "cheatmux.tmux sources helpers.sh" {
    grep -q 'source "${CURRENT_DIR}/scripts/helpers.sh"' "${PROJECT_ROOT}/cheatmux.tmux"
}

@test "cheatmux.tmux calls version_check" {
    grep -q 'version_check "3.2"' "${PROJECT_ROOT}/cheatmux.tmux"
}

@test "cheatmux.tmux reads @cheatmux-key option with ? default" {
    grep -q 'get_tmux_option "@cheatmux-key" "?"' "${PROJECT_ROOT}/cheatmux.tmux"
}

@test "cheatmux.tmux registers bind-key with run-shell" {
    grep -q 'tmux bind-key "$key" run-shell' "${PROJECT_ROOT}/cheatmux.tmux"
}
