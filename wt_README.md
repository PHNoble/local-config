# wt — git worktree manager

Worktree tooling integrated with tmux, starship, oh-my-zsh, and omp.

## Layout

Worktrees live in a global folder, outside every repo:

```
~/.worktrees/{repo}/{gemstone}/   <- one worktree, dir named after a gemstone
```

Each new worktree gets a random unused gemstone name (diamond, ruby, sapphire,
emerald, amethyst, topaz, opal, pearl, jade, garnet, aquamarine, citrine,
tourmaline, peridot, moonstone, tanzanite, alexandrite, spinel, kunzite,
morganite) for readable paths and tmux window names. If all 20 are taken, the
branch name (slashes -> dashes) is used instead.

There is **no mapping file**: `git worktree list` is the single source of
truth, so nothing can drift. Every command accepts either the gemstone or the
branch name.

Worktrees of the same repo created by *other* tools (codex, omp `isolated`,
manual `git worktree add`) are shown as `[ext]` in listings and the picker.
They can be opened/jumped into and removed with `wt rm`, but `wt clean`
never touches them.

## Commands (`scripts/wt`, on PATH)

| command | what it does |
|---|---|
| `wt` | fzf picker: enter opens in tmux, `ctrl-n` creates a worktree from the typed text (works on an empty list) |
| `wt new <branch> [base]` | create worktree; handles new branch (base defaults to `origin/HEAD`), existing local branch, and `origin/<branch>` tracking; jumps to the worktree if the branch already has one |
| `wt ls` | list worktrees (`*` = dirty), then an `external:` section |
| `wt rm [-f\|-d] [name\|branch ...]` | remove worktrees, external ones included; fzf multi-select (tab) with no args; default refuses dirty trees and deletes the branch only if merged; `-f` discards changes **and** force-deletes the branch; `-d` discards changes but **keeps** the branch |
| `wt clean` | remove worktrees that are merged into the default branch, upstream-gone, **or detached** — clean working trees only, one confirmation |
| `wt clean --idle` | remove worktrees no open tmux pane is cd'd into (clean trees only; unmerged branches are kept, only the dir goes) |
| `wt root` | open the main repo in tmux |
| `wt path [name]` | print a worktree path (picker with no args) — for `cd`/scripting |

Safety rules shared by `rm`/`clean`: dirty trees are never auto-removed,
branch deletion uses `git branch -d` unless forced, and a pane sitting
anywhere *inside* a worktree protects it from `--idle`.

### Env vars

- `WT_ROOT` — override `~/.worktrees`
- `WT_NO_TMUX=1` — print the worktree path instead of opening tmux
  (used by the omp extension and scripts)

### Per-repo init hook

If `~/.worktrees/{repo}/init.sh` exists and is executable, it runs inside
every newly created worktree (dependency install etc.).

### Graphite

New branches are `gt branch track`ed automatically (non-interactive; skipped
silently if graphite isn't set up).

## tmux integration

- One tmux **session per repo**, one **window per worktree**, named after the
  gemstone. Inside tmux, windows open in the current session instead.
- New windows get the 3-pane layout: full-height pane left (active), two
  stacked panes right, all cd'd to the worktree.
- `prefix + g` (tmux.conf) opens the picker in a popup. Gemstone names are
  colored (256-color versions of each stone's color), `[ext]` entries are
  dimmed, and errors pause the popup instead of closing it.
- `wt rm` kills the matching tmux window instead of refusing.

## oh-my-zsh plugin (`zsh/wt/`, symlinked to `$ZSH/custom/plugins/wt`)

Registered in `zshrc` via `plugins=(git wt)`. Provides:

- `wtcd [name]` — cd into a worktree (picker with no arg)
- `wtn` / `wtl` — aliases for `wt new` / `wt ls`
- tab completion: subcommands, worktree names for `rm`/`path`, branches for `new`

## starship (`starship.toml`, `[custom.worktree]`)

An orange ` {repo}` pill appears in the prompt whenever `$PWD` is under
`~/.worktrees` — the directory segment next to it already shows
`{repo}/{gemstone}`, so together they tell you exactly where you are.

## omp extension (`omp/wt.ts`, symlinked to `~/.omp/agent/extensions/wt.ts`)

- **Status line**: ` {gemstone}` is shown whenever the session's cwd is
  inside a wt-managed worktree (updates on session start/switch and every
  turn; requires `statusLine.showHookStatus`, on by default).
- **`/wt` command**: `/wt ls | new <branch> [base] | rm <name> | clean | path <name>`
  runs the script (non-interactively, auto-confirming `clean`) and shows the
  output as a notification.
- **`worktree` tool**: lets the agent create/list/remove/resolve worktrees
  with the same conventions (`action`, `branch`, `base`, `force` params).

## Files

| file | role |
|---|---|
| `scripts/wt` | the manager script |
| `zsh/wt/wt.plugin.zsh` | oh-my-zsh plugin (functions + completion) |
| `omp/wt.ts` | omp extension (status line, `/wt`, `worktree` tool) |
| `tmux.conf` | `prefix + g` popup binding |
| `starship.toml` | `[custom.worktree]` prompt segment |
| `zshrc` | `plugins=(git wt)` |

Symlinks (created by `./init-local.sh`; safe to re-run on a new machine):

```sh
ln -sfn ~/.config/zsh/wt ~/.oh-my-zsh/custom/plugins/wt
ln -sf  ~/.config/omp/wt.ts ~/.omp/agent/extensions/wt.ts
```

Requires: git, tmux, fzf (`brew install fzf`). Optional: gt (graphite), omp.
