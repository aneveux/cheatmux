#!/usr/bin/env bats
# Tests for default cheatsheet.md content structure

load test_helper

@test "cheatsheet.md: has exactly 7 section headers" {
    local count
    count=$(grep -c "^## " "$PROJECT_ROOT/cheatsheet.md")

    [ "$count" -eq 7 ]
}

@test "cheatsheet.md: has at least 25 shortcut lines" {
    local count
    count=$(grep -c "^prefix + " "$PROJECT_ROOT/cheatsheet.md")

    [ "$count" -ge 25 ]
}

@test "cheatsheet.md: contains all expected sections" {
    local file="$PROJECT_ROOT/cheatsheet.md"

    # Check each expected section exists
    grep -q "^## Sessions" "$file"
    grep -q "^## Windows" "$file"
    grep -q "^## Panes" "$file"
    grep -q "^## Navigation" "$file"
    grep -q "^## Resize" "$file"
    grep -q "^## Copy Mode" "$file"
    grep -q "^## Misc" "$file"
}

@test "cheatsheet.md: has no unexpected sections" {
    local file="$PROJECT_ROOT/cheatsheet.md"
    local unexpected_count

    # Count sections that don't match any expected pattern
    unexpected_count=$(grep "^## " "$file" | \
        grep -v -E "^## (Sessions|Windows|Panes|Navigation|Resize|Copy Mode|Misc)$" | \
        wc -l)

    # Should be zero
    [ "$unexpected_count" -eq 0 ]
}

@test "cheatsheet.md: renders without errors via render.sh" {
    run "$PROJECT_ROOT/scripts/render.sh" "$PROJECT_ROOT/cheatsheet.md"

    [ "$status" -eq 0 ]
    # Should have output (not empty)
    [ -n "$output" ]
    # Should not contain error messages
    ! [[ "$output" =~ "Error" ]]
}
