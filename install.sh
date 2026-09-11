#!/bin/bash
# Bootstrap this machine from ~/.config. Idempotent: re-run any time.
# Assumes macOS with Homebrew and iTerm2 already installed.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PATH="/opt/homebrew/bin:$PATH"

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }

# link <repo-relative-path> <target>: symlink, backing up any real file in the way.
link() {
    local src="$DIR/$1" dst="$2"
    [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ] && return
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        mv "$dst" "$dst.bak" && echo "backed up $dst -> $dst.bak"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst" && echo "linked $dst"
}

step "brew bundle"
brew trust can1357/tap oven-sh/bun withgraphite/tap
brew bundle --file="$DIR/Brewfile" --no-upgrade

step "dotfile symlinks"
link zshrc ~/.zshrc
link tmux.conf ~/.tmux.conf
link claude/settings.json ~/.claude/settings.json
# starship.toml, nvim/, git/{config,ignore}, gh/ are read from ~/.config directly.

step "oh-my-zsh"
if [ ! -d ~/.oh-my-zsh ]; then
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi
link zsh/wt ~/.oh-my-zsh/custom/plugins/wt
for p in zsh-autosuggestions zsh-syntax-highlighting; do
    [ -d ~/.oh-my-zsh/custom/plugins/$p ] || git clone --depth 1 https://github.com/zsh-users/$p ~/.oh-my-zsh/custom/plugins/$p
done

step "nvm + node"
if [ ! -d ~/.nvm ]; then
    PROFILE=/dev/null bash -c "$(curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh)"
fi
. ~/.nvm/nvm.sh
nvm version default >/dev/null || nvm install node # latest; becomes default

step "rust"
if [ ! -x ~/.cargo/bin/rustup ]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

step "python"
[ "$(pyenv global)" != system ] || { pyenv install --skip-existing 3 && pyenv global "$(pyenv latest 3)"; }

step "tmux plugins"
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
~/.tmux/plugins/tpm/bin/install_plugins

step "neovim plugins"
nvim --headless "+Lazy! restore" +qa || echo "nvim plugin restore failed; open nvim and run :Lazy restore"

step "omp"
link omp/config.yml ~/.omp/agent/config.yml
link omp/wt.ts ~/.omp/agent/extensions/wt.ts
marketplaces=(anthropics/claude-plugins-official DietrichGebert/ponytail)
plugins=(datadog@claude-plugins-official ponytail@ponytail)
have_mp=$(omp plugin marketplace list 2>/dev/null || true)
for mp in "${marketplaces[@]}"; do
    grep -qF "$mp" <<<"$have_mp" || omp plugin marketplace add "$mp"
done
have_pl=$(omp plugin list 2>/dev/null || true)
for pl in "${plugins[@]}"; do
    grep -qF "$pl" <<<"$have_pl" || omp plugin install "$pl"
done
if [ ! -f ~/.omp/agent/.env ]; then
    echo "ANTHROPIC_API_KEY=" > ~/.omp/agent/.env
    echo "TODO: set ANTHROPIC_API_KEY in ~/.omp/agent/.env"
fi

step "cursor"
[ -d /Applications/Cursor.app ] || brew install --cask cursor
link cursor/settings.json "$HOME/Library/Application Support/Cursor/User/settings.json"
link cursor/keybindings.json "$HOME/Library/Application Support/Cursor/User/keybindings.json"
have_ext=$(cursor --list-extensions 2>/dev/null || true)
while read -r ext; do
    grep -qiF "$ext" <<<"$have_ext" || cursor --install-extension "$ext"
done < "$DIR/cursor/extensions.txt"

step "iterm2"
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DIR/iterm"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

step "done"
echo "Restart iTerm2 to pick up prefs. Then: gh auth login, gt auth."
