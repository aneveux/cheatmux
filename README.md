# cheatmux

[![CI](https://github.com/aneveux/cheatmux/actions/workflows/ci.yml/badge.svg)](https://github.com/aneveux/cheatmux/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/github/license/aneveux/cheatmux)](https://github.com/aneveux/cheatmux/blob/master/LICENSE)

Instantly surface forgotten tmux shortcuts without leaving the terminal.

## Installation

### TPM (recommended)

Add to `~/.tmux.conf`:

```tmux
set -g @plugin 'aneveux/cheatmux'
```

Press `prefix + I` to install.

### Manual

```bash
git clone https://github.com/aneveux/cheatmux ~/.tmux/plugins/cheatmux
```

Add to `~/.tmux.conf`:

```tmux
run-shell ~/.tmux/plugins/cheatmux/cheatmux.tmux
```

Reload: `tmux source ~/.tmux.conf`

## Usage

Press `prefix + ?` to open the cheatsheet popup.

When [fzf](https://github.com/junegunn/fzf) is installed, the popup opens in fuzzy search mode. Type to filter shortcuts.

When fzf is not installed, the popup opens in the pager (less) directly.

## Configuration

Custom keybinding:

```tmux
set -g @cheatmux-key 'C-h'
```

Custom cheatsheet path:

```tmux
set -g @cheatmux-path '~/my-cheatsheet.md'
```

### Cheatsheet discovery

The plugin looks for a cheatsheet in this order:

1. `@cheatmux-path` tmux option (if set)
2. `$XDG_CONFIG_HOME/cheatmux/cheatsheet.md`
3. `~/.config/cheatmux/cheatsheet.md`
4. `$XDG_DATA_HOME/cheatmux/cheatsheet.md`
5. `~/.local/share/cheatmux/cheatsheet.md`
6. Bundled default (plugin directory)

To use your own cheatsheet, create `~/.config/cheatmux/cheatsheet.md` or set `@cheatmux-path`.

### Cheatsheet format

```
## Section Name
prefix + key    Description
```

## Requirements

- tmux 3.2+ (uses `display-popup`)
- bash 4.0+
- [fzf](https://github.com/junegunn/fzf) (optional, enables fuzzy search)
