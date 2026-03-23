# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-03-23

### Added

- XDG Base Directory support for cheatsheet discovery (`$XDG_CONFIG_HOME/cheatmux/cheatsheet.md` and `~/.config/cheatmux/cheatsheet.md`)
- Fuzzy search with fzf integration (opens directly into fzf when available)
- Graceful fallback to less pager when fzf is not installed
- FZF_DEFAULT_OPTS isolation to prevent user config conflicts
- GitHub Actions CI pipeline (ShellCheck, Bats tests, markdown lint)
- Release automation via tag push

### Changed

- Default bundled cheatsheet renamed from `cheatsheet.txt` to `cheatsheet.md`

[Unreleased]: https://github.com/aneveux/cheatmux/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/aneveux/cheatmux/releases/tag/v1.0.0
