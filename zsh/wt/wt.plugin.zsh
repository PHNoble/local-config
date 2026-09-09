# oh-my-zsh plugin for wt (git worktree manager)
# Source lives in ~/.config/zsh/wt; symlinked to $ZSH_CUSTOM/plugins/wt.

# cd into a worktree (fzf picker when no arg)
wtcd() {
    local dir
    dir=$(command wt path "$@") || return 1
    cd "$dir"
}

alias wtn='wt new'
alias wtl='wt ls'

# worktree names; pass "all" to include the "external:" section entries
_wt_names() {
    local -a names
    if [[ "${1:-}" == all ]]; then
        names=(${(f)"$(command wt ls 2>/dev/null | awk '$1 != "external:" {print $1}')"})
    else
        names=(${(f)"$(command wt ls 2>/dev/null | awk '/^external:/{exit} {print $1}')"})
    fi
    _describe 'worktree' names
}

_wt() {
    local -a subcmds
    subcmds=(
        'new:create worktree (new or existing branch)'
        'ls:list worktrees'
        'rm:remove worktrees (-f force, -d discard changes keep branch)'
        'clean:remove merged/gone worktrees (--idle: no open tmux pane)'
        'root:open main repo in tmux'
        'path:print worktree path'
        'help:show usage'
    )

    if (( CURRENT == 2 )); then
        _describe 'wt command' subcmds
        return
    fi

    case "${words[2]}" in
        rm|delete|remove|path|cd)
            _wt_names all
            ;;
        new|create)
            local -a branches
            branches=(${(f)"$(git branch --format='%(refname:short)' 2>/dev/null)"})
            _describe 'branch' branches
            ;;
    esac
}
compdef _wt wt

_wtcd() { _wt_names all }
compdef _wtcd wtcd
