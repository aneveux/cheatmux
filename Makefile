.PHONY: lint test check

lint:
	shellcheck scripts/*.sh *.tmux

test:
	bats test/*.bats

check: lint test
