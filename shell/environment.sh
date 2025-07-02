#!/bin/bash
# Unified environment variables for all shells

# Editor settings
export EDITOR=nvim
export VISUAL=nvim

# Python settings
export PIP_REQUIRE_VIRTUALENV=True
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
export PYTHONSTARTUP=$HOME/.pythonrc

# pnpm home (also used in path.sh)
export PNPM_HOME="$HOME/Library/pnpm"

# History settings (for shells that respect these)
export HISTSIZE=1048576
export SAVEHIST=$HISTSIZE

# Terminal settings
export KEYTIMEOUT=1  # corresponds to 10ms for zsh

# Java location (uncomment if needed)
# export JAVA_HOME="$(/usr/libexec/java_home)"

