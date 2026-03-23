# Cheatmux - tmux Quick Reference
# Edit this file or set a custom path with: tmux set -g @cheatmux-path /path/to/file

## Sessions
prefix + s    List all sessions
prefix + $    Rename current session
prefix + d    Detach from session
prefix + (    Switch to previous session
prefix + )    Switch to next session

## Windows
prefix + c    Create new window
prefix + n    Next window
prefix + p    Previous window
prefix + w    Choose window from list
prefix + ,    Rename current window
prefix + &    Close current window

## Panes
prefix + %    Split pane vertically
prefix + "    Split pane horizontally
prefix + o    Cycle through panes
prefix + x    Close current pane
prefix + z    Toggle pane zoom

## Navigation
prefix + q    Show pane numbers (then press number to jump)
prefix + ;    Toggle last active pane
prefix + l    Toggle last active window

## Resize
prefix + H    Resize pane left (repeat)
prefix + J    Resize pane down (repeat)
prefix + K    Resize pane up (repeat)
prefix + L    Resize pane right (repeat)

## Copy Mode
prefix + [    Enter copy mode
prefix + ]    Paste from buffer
q             Exit copy mode

## Misc
prefix + t    Show clock
prefix + :    Enter command mode
prefix + r    Reload tmux config (if bound)
