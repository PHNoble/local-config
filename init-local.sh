#!/bin/bash

# Get the absolute path of the directory the script is in
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -s "$DIR/zshrc" ~/.zshrc
ln -s "$DIR/tmux.conf" ~/.tmux.conf