
#-------------------------------------------------------------------------------
# Docker
#-------------------------------------------------------------------------------

alias dc="docker-compose"

#-------------------------------------------------------------------------------
# Git (sensible aliases + https://hackernoon.com/be-125-more-efficient-with-git-60556a1ce971)
#   - smart shortcut (frequenty usage)  ->  (g${short-command} - like gl for [git log]
#   - MOST of these will be overridden by functions in ".functions.sh"
#-------------------------------------------------------------------------------

# GIT CONFIG
alias gcnf='git config'

# GIT STATUS
alias gs='git status'

# GIT log
# .function gl

# GIT BRANCH
# .function gb()
# .function gba()
alias gbd='git branch -d'
alias gbdd='git push origin --delete'

# GIT CHECKOUT
alias gco='git checkout $(gb)' # command single quoted to avoid execution before alias call
alias gcoa='git checkout $(gba)' # command single quoted to avoid execution before alias call
alias gcob="git checkout -b"

# GIT ADD
alias ga='git add -i'
alias gaa='git add --all'
alias gap='git add --patch'

# GIT COMMIT
alias gc='git commit -v'
alias gc!='git commit -v --amend'
# -a option : auto stage ("add") added/modified but don't mind files not known to git
alias gca='git commit -v -a'
alias gca!='git commit -v -a --amend'

# GIT BLAME
alias gbl='git blame'

# GIT STASH
alias gst='git stash'

# GIT PUSH
# .function gsh()

# GIT PULL
alias gll='git pull'

# GIT DIFF
alias gd='git diff'

# GIT worktree
alias gw='git worktree'

# GIT MERGE
alias gm='git merge'
alias gma='git merge --abort'

# GIT REBASE (useful for squashing commits too) -- Squashing 4 commits (git rebase -i HEAD~4)
# alias gr="git rebase"
alias gri='git rebase -i'
alias gra='git rebase --abort'
alias grc='git rebase --continue'

#-------------------------------------------------------------------------------
# Improving CLI toolset (more modern tooling)
# - https://remysharp.com/2018/08/23/cli-improved
# - https://news.ycombinator.com/item?id=26559334
#-------------------------------------------------------------------------------

alias grep='rg'
alias find='fd'
# TODO: find a way to make this work with alias - NVM script (NVM_DIR/.nvm.sh) expects "sed" and provides some specific flags that are not in "sd"
# alias sed='sd'
alias diff='delta'
alias ls='eza -al'
alias cat='bat'
alias du='dust -X .git'
alias ps='procs'
alias top='htop'
alias ping='prettyping --nolegend'
alias help='tldr'
alias xxd='hexyl'

#-------------------------------------------------------------------------------
# Vim -> NVim (muscle memory)
#-------------------------------------------------------------------------------
if type nvim > /dev/null 2>&1; then
  alias vim='nvim'
fi

#-------------------------------------------------------------------------------
# Tailscale CLI (https://tailscale.com/kb/1080/cli#using-the-cli)
#-------------------------------------------------------------------------------
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
