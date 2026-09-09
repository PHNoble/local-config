#!/bin/bash

# Get the absolute path of the directory the script is in
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -s "$DIR/zshrc" ~/.zshrc
ln -s "$DIR/tmux.conf" ~/.tmux.conf

# wt worktree tooling (see wt_README.md)
mkdir -p ~/.oh-my-zsh/custom/plugins ~/.omp/agent/extensions
ln -sfn "$DIR/zsh/wt" ~/.oh-my-zsh/custom/plugins/wt
ln -sf "$DIR/omp/wt.ts" ~/.omp/agent/extensions/wt.ts