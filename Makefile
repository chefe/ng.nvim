MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
PROJECT_PATH := $(patsubst %/,%,$(dir $(MKFILE_PATH)))
export PATH := ${PROJECT_PATH}/build/ext/bin:${PATH}

.PHONY: all ci lint shellcheck stylua setup clean

all: ci

ci: lint

lint: shellcheck stylua

shellcheck: setup
	shellcheck --enable=all --severity=style .envrc scripts/*

stylua: setup
	stylua --check lua

setup:
	./scripts/setup_toolchain

clean:
	rm -rf build
