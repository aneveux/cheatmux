# Contributing to cheatmux

## Development Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/aneveux/cheatmux
   cd cheatmux
   ```

2. Install dependencies:

   ```bash
   npm install -g bats
   sudo apt-get install tmux shellcheck
   ```

3. Run tests:

   ```bash
   make test
   ```

4. Run linting:

   ```bash
   make lint
   ```

## Making Changes

- Create a feature branch from `master`
- Add tests for new functionality
- Ensure all tests pass before submitting a PR

## Pull Requests

PRs should:

- Include a clear description of the change
- Pass CI checks (ShellCheck, Bats tests, markdown lint)
- Update README if adding user-facing features
