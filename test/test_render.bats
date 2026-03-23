#!/usr/bin/env bats
# Tests for scripts/render.sh - cheatsheet ANSI color renderer

load test_helper

setup() {
    # Create temporary cheatsheet files for testing
    export TEMP_DIR="${BATS_TEST_TMPDIR}/cheatmux_$$"
    mkdir -p "$TEMP_DIR"
}

teardown() {
    rm -rf "$TEMP_DIR"
}

@test "render.sh: section header outputs bold cyan ANSI" {
    local test_file="$TEMP_DIR/test.txt"
    echo "## Sessions" > "$test_file"

    run "$PROJECT_ROOT/scripts/render.sh" "$test_file"

    [ "$status" -eq 0 ]
    # Check for ANSI escape codes: bold cyan (1;36m) and reset (0m)
    [[ "$output" == *$'\033[1;36m'* ]]
    [[ "$output" =~ Sessions ]]
    [[ "$output" == *$'\033[0m'* ]]
}

@test "render.sh: shortcut line outputs green key portion with reset" {
    local test_file="$TEMP_DIR/test.txt"
    echo "prefix + s    List sessions" > "$test_file"

    run "$PROJECT_ROOT/scripts/render.sh" "$test_file"

    [ "$status" -eq 0 ]
    # Check for bold green ANSI (1;32m) for the key portion
    [[ "$output" == *$'\033[1;32m'* ]]
    [[ "$output" =~ "prefix + s" ]]
    [[ "$output" =~ "List sessions" ]]
    [[ "$output" == *$'\033[0m'* ]]
}

@test "render.sh: comment line produces no output" {
    local test_file="$TEMP_DIR/test.txt"
    echo "# This is a comment" > "$test_file"
    echo "## Section" >> "$test_file"

    run "$PROJECT_ROOT/scripts/render.sh" "$test_file"

    [ "$status" -eq 0 ]
    # Comment should not appear in output, only section
    ! [[ "$output" =~ "This is a comment" ]]
    [[ "$output" =~ "Section" ]]
}

@test "render.sh: blank line produces empty line in output" {
    local test_file="$TEMP_DIR/test.txt"
    echo "" > "$test_file"
    echo "" >> "$test_file"

    run "$PROJECT_ROOT/scripts/render.sh" "$test_file"

    [ "$status" -eq 0 ]
    # Should have output (empty lines preserved)
    [ -n "$output" ]
}

@test "render.sh: missing file prints error and exits 1" {
    local nonexistent="$TEMP_DIR/nonexistent.txt"

    run "$PROJECT_ROOT/scripts/render.sh" "$nonexistent"

    [ "$status" -eq 1 ]
    [[ "$output" =~ "Error" ]]
    [[ "$output" =~ "not found" ]]
}

@test "render.sh: empty file prints empty cheatsheet message" {
    local test_file="$TEMP_DIR/empty.txt"
    touch "$test_file"

    run "$PROJECT_ROOT/scripts/render.sh" "$test_file"

    [ "$status" -eq 0 ]
    [[ "$output" =~ "Cheatsheet is empty" ]]
}

@test "render.sh: file with only comments prints empty cheatsheet message" {
    local test_file="$TEMP_DIR/only_comments.txt"
    echo "# Comment 1" > "$test_file"
    echo "# Comment 2" >> "$test_file"
    echo "# Comment 3" >> "$test_file"

    run "$PROJECT_ROOT/scripts/render.sh" "$test_file"

    [ "$status" -eq 0 ]
    [[ "$output" =~ "Cheatsheet is empty" ]]
}

@test "render.sh: line with no pattern match passes through unmodified" {
    local test_file="$TEMP_DIR/test.txt"
    echo "Some random text without pattern" > "$test_file"

    run "$PROJECT_ROOT/scripts/render.sh" "$test_file"

    [ "$status" -eq 0 ]
    [[ "$output" =~ "Some random text without pattern" ]]
    # Should NOT have color codes for unmatched line
    ! [[ "$output" == *$'\033[1;32m'* ]]
    ! [[ "$output" == *$'\033[1;36m'* ]]
}
