# ~/.config

Personal dotfiles. Clone to `~/.config` and run `./install.sh`.

```sh
git clone git@github.com:PHNoble/local-config.git ~/.config && ~/.config/install.sh
```

Assumes macOS with Homebrew and iTerm2 installed. Idempotent: re-run after
editing the `Brewfile` or adding files.

## What it sets up

| Tool | Config | Installed by |
|---|---|---|
| zsh / oh-my-zsh | `zshrc` -> `~/.zshrc`; zsh-autosuggestions, zsh-syntax-highlighting | omz installer, git clone |
| starship | `starship.toml` (read in place) | brew |
| tmux + tpm | `tmux.conf` -> `~/.tmux.conf` | brew, tpm clone + `install_plugins` |
| neovim (AstroNvim) | `nvim/` (read in place) | brew, `Lazy! restore` |
| omp | `omp/config.yml` -> `~/.omp/agent/config.yml`, `omp/wt.ts` extension, marketplaces + plugins | brew (`can1357/tap`) |
| git | `git/config`, `git/ignore` (read in place) | - |
| node | latest via nvm (`nvm install node`, first run only) | nvm installer |
| python | latest 3.x via pyenv, set as global (first run only) | brew |
| bun, elixir/erlang, gh, graphite, fzf, ripgrep | `gh/` (read in place) | brew |
| rust | stable toolchain in `~/.cargo` | rustup installer |
| iTerm2 | `iterm/` via `LoadPrefsFromCustomFolder` | preinstalled |
| Nerd Font | Comic Shanns Mono | brew cask |
| claude | `claude/settings.json` -> `~/.claude/settings.json` | - |
| wt | `scripts/wt`, `zsh/wt` plugin. See `wt_README.md` | - |

## Not tracked

- `~/.omp/agent/.env` (API keys): created empty, fill in by hand.
- `~/.zshrc.local`: machine/work-specific PATH and env, sourced by `zshrc`.
- `gh auth login`, `gt auth`: run once after install.
