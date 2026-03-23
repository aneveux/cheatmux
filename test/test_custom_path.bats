#!/usr/bin/env bats

setup() {
    source "${BATS_TEST_DIRNAME}/test_helper.bash"
}

teardown() {
    reset_tmux_mock
    rm -f /tmp/test_cheatsheet_*.txt /tmp/test_cheatsheet_*.md
}

@test "cheatmux.sh reads @cheatmux-path option" {
    grep -q "@cheatmux-path" "${PROJECT_ROOT}/scripts/cheatmux.sh"
}

@test "helpers.sh has tilde expansion logic" {
    grep -qF '/#\~/' "${PROJECT_ROOT}/scripts/helpers.sh"
}

@test "cheatmux.sh has default path pointing to cheatsheet.md" {
    grep -q 'resolve_cheatsheet_path' "${PROJECT_ROOT}/scripts/cheatmux.sh"
}

@test "render.sh exits 1 when given nonexistent file path" {
    run "${PROJECT_ROOT}/scripts/render.sh" /tmp/nonexistent_cheatsheet_12345.txt
    [ "$status" -eq 1 ]
}

@test "render.sh exits 0 when given valid custom file" {
    # Create temp file with content
    local temp_file="/tmp/test_cheatsheet_$$_valid.txt"
    cat > "$temp_file" << 'EOF'
## Test Section
prefix + t    Test shortcut
EOF

    run "${PROJECT_ROOT}/scripts/render.sh" "$temp_file"
    [ "$status" -eq 0 ]
}

# --- XDG Path Resolution Tests ---

@test "resolve_cheatsheet_path honors XDG_CONFIG_HOME when set" {
    source "${PROJECT_ROOT}/scripts/helpers.sh"
    local test_dir="/tmp/cheatmux_xdg_test_$$"
    mkdir -p "$test_dir/cheatmux"
    echo "xdg test" > "$test_dir/cheatmux/cheatsheet.md"

    XDG_CONFIG_HOME="$test_dir" \
        run bash -c "source '${PROJECT_ROOT}/scripts/helpers.sh'; resolve_cheatsheet_path '' '${PROJECT_ROOT}/cheatsheet.md'"

    [ "$status" -eq 0 ]
    [ "$output" = "$test_dir/cheatmux/cheatsheet.md" ]

    rm -rf "$test_dir"
}

@test "resolve_cheatsheet_path falls back to default config when XDG_CONFIG_HOME unset" {
    source "${PROJECT_ROOT}/scripts/helpers.sh"
    local test_dir="/tmp/cheatmux_home_test_$$"
    mkdir -p "$test_dir/.config/cheatmux"
    echo "default config test" > "$test_dir/.config/cheatmux/cheatsheet.md"

    HOME="$test_dir" XDG_CONFIG_HOME="" \
        run bash -c "source '${PROJECT_ROOT}/scripts/helpers.sh'; resolve_cheatsheet_path '' '${PROJECT_ROOT}/cheatsheet.md'"

    [ "$status" -eq 0 ]
    [ "$output" = "$test_dir/.config/cheatmux/cheatsheet.md" ]

    rm -rf "$test_dir"
}

@test "resolve_cheatsheet_path prioritizes @cheatmux-path over XDG" {
    source "${PROJECT_ROOT}/scripts/helpers.sh"
    local test_dir="/tmp/cheatmux_priority_test_$$"
    mkdir -p "$test_dir/xdg/cheatmux"
    echo "xdg" > "$test_dir/xdg/cheatmux/cheatsheet.md"
    echo "custom" > "$test_dir/custom.md"

    XDG_CONFIG_HOME="$test_dir/xdg" \
        run bash -c "source '${PROJECT_ROOT}/scripts/helpers.sh'; resolve_cheatsheet_path '$test_dir/custom.md' '${PROJECT_ROOT}/cheatsheet.md'"

    [ "$status" -eq 0 ]
    [ "$output" = "$test_dir/custom.md" ]

    rm -rf "$test_dir"
}

@test "resolve_cheatsheet_path uses plugin default when no user paths exist" {
    source "${PROJECT_ROOT}/scripts/helpers.sh"
    local test_dir="/tmp/cheatmux_nopath_test_$$"
    mkdir -p "$test_dir"

    HOME="$test_dir" XDG_CONFIG_HOME="" \
        run bash -c "source '${PROJECT_ROOT}/scripts/helpers.sh'; resolve_cheatsheet_path '' '${PROJECT_ROOT}/cheatsheet.md'"

    [ "$status" -eq 0 ]
    [ "$output" = "${PROJECT_ROOT}/cheatsheet.md" ]

    rm -rf "$test_dir"
}

@test "resolve_cheatsheet_path skips XDG_CONFIG_HOME when file does not exist there" {
    source "${PROJECT_ROOT}/scripts/helpers.sh"
    local test_dir="/tmp/cheatmux_skip_test_$$"
    mkdir -p "$test_dir/cheatmux"
    # Directory exists but no cheatsheet.md file inside

    XDG_CONFIG_HOME="$test_dir" XDG_DATA_HOME="" HOME="/tmp/nonexistent_home_$$" \
        run bash -c "source '${PROJECT_ROOT}/scripts/helpers.sh'; resolve_cheatsheet_path '' '${PROJECT_ROOT}/cheatsheet.md'"

    [ "$status" -eq 0 ]
    [ "$output" = "${PROJECT_ROOT}/cheatsheet.md" ]

    rm -rf "$test_dir"
}

@test "resolve_cheatsheet_path handles tilde in custom path" {
    source "${PROJECT_ROOT}/scripts/helpers.sh"
    local test_dir="/tmp/cheatmux_tilde_test_$$"
    mkdir -p "$test_dir"
    echo "tilde test" > "$test_dir/my-cheat.md"

    HOME="$test_dir" \
        run bash -c "export HOME='$test_dir'; source '${PROJECT_ROOT}/scripts/helpers.sh'; resolve_cheatsheet_path '~/my-cheat.md' '${PROJECT_ROOT}/cheatsheet.md'"

    [ "$status" -eq 0 ]
    [ "$output" = "$test_dir/my-cheat.md" ]

    rm -rf "$test_dir"
}

# --- XDG_DATA_HOME Path Resolution Tests ---

@test "resolve_cheatsheet_path honors XDG_DATA_HOME when set" {
    source "${PROJECT_ROOT}/scripts/helpers.sh"
    local test_dir="/tmp/cheatmux_xdg_data_test_$$"
    mkdir -p "$test_dir/cheatmux"
    echo "xdg data test" > "$test_dir/cheatmux/cheatsheet.md"

    XDG_DATA_HOME="$test_dir" XDG_CONFIG_HOME="" HOME="/tmp/nonexistent_home_$$" \
        run bash -c "source '${PROJECT_ROOT}/scripts/helpers.sh'; resolve_cheatsheet_path '' '${PROJECT_ROOT}/cheatsheet.md'"

    [ "$status" -eq 0 ]
    [ "$output" = "$test_dir/cheatmux/cheatsheet.md" ]

    rm -rf "$test_dir"
}

@test "resolve_cheatsheet_path falls back to default data dir when XDG_DATA_HOME unset" {
    source "${PROJECT_ROOT}/scripts/helpers.sh"
    local test_dir="/tmp/cheatmux_data_home_test_$$"
    mkdir -p "$test_dir/.local/share/cheatmux"
    echo "default data test" > "$test_dir/.local/share/cheatmux/cheatsheet.md"

    HOME="$test_dir" XDG_CONFIG_HOME="" XDG_DATA_HOME="" \
        run bash -c "source '${PROJECT_ROOT}/scripts/helpers.sh'; resolve_cheatsheet_path '' '${PROJECT_ROOT}/cheatsheet.md'"

    [ "$status" -eq 0 ]
    [ "$output" = "$test_dir/.local/share/cheatmux/cheatsheet.md" ]

    rm -rf "$test_dir"
}

@test "resolve_cheatsheet_path prioritizes XDG_CONFIG_HOME over XDG_DATA_HOME" {
    source "${PROJECT_ROOT}/scripts/helpers.sh"
    local test_dir="/tmp/cheatmux_config_data_priority_test_$$"
    mkdir -p "$test_dir/config/cheatmux"
    mkdir -p "$test_dir/data/cheatmux"
    echo "config" > "$test_dir/config/cheatmux/cheatsheet.md"
    echo "data" > "$test_dir/data/cheatmux/cheatsheet.md"

    XDG_CONFIG_HOME="$test_dir/config" XDG_DATA_HOME="$test_dir/data" \
        run bash -c "source '${PROJECT_ROOT}/scripts/helpers.sh'; resolve_cheatsheet_path '' '${PROJECT_ROOT}/cheatsheet.md'"

    [ "$status" -eq 0 ]
    [ "$output" = "$test_dir/config/cheatmux/cheatsheet.md" ]

    rm -rf "$test_dir"
}

@test "resolve_cheatsheet_path prioritizes XDG_DATA_HOME over plugin default" {
    source "${PROJECT_ROOT}/scripts/helpers.sh"
    local test_dir="/tmp/cheatmux_data_default_priority_test_$$"
    mkdir -p "$test_dir/cheatmux"
    echo "data" > "$test_dir/cheatmux/cheatsheet.md"

    XDG_DATA_HOME="$test_dir" XDG_CONFIG_HOME="" HOME="/tmp/nonexistent_home_$$" \
        run bash -c "source '${PROJECT_ROOT}/scripts/helpers.sh'; resolve_cheatsheet_path '' '${PROJECT_ROOT}/cheatsheet.md'"

    [ "$status" -eq 0 ]
    [ "$output" = "$test_dir/cheatmux/cheatsheet.md" ]

    rm -rf "$test_dir"
}

@test "resolve_cheatsheet_path skips XDG_DATA_HOME when file does not exist there" {
    source "${PROJECT_ROOT}/scripts/helpers.sh"
    local test_dir="/tmp/cheatmux_skip_data_test_$$"
    mkdir -p "$test_dir/cheatmux"
    # Directory exists but no cheatsheet.md file inside

    XDG_DATA_HOME="$test_dir" XDG_CONFIG_HOME="" HOME="/tmp/nonexistent_home_$$" \
        run bash -c "source '${PROJECT_ROOT}/scripts/helpers.sh'; resolve_cheatsheet_path '' '${PROJECT_ROOT}/cheatsheet.md'"

    [ "$status" -eq 0 ]
    [ "$output" = "${PROJECT_ROOT}/cheatsheet.md" ]

    rm -rf "$test_dir"
}
