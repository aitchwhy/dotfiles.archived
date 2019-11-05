#-------------------------------------------------------------------------------
# Path to your dotfiles installation.
#-------------------------------------------------------------------------------
export DOTFILES=$HOME/dotfiles

#-------------------------------------------------------------------------------
# Path to oh-my-zsh installation
#-------------------------------------------------------------------------------
export ZSH=$HOME/.oh-my-zsh

#-------------------------------------------------------------------------------
# Set default EDITOR env var to Path to your Vim binary
#-------------------------------------------------------------------------------

export EDITOR=nvim

#-------------------------------------------------------------------------------
# Shell prompt + theme setting
#
# Set name of the theme to load
#-------------------------------------------------------------------------------
# Source powerlevel9k
source /usr/local/opt/powerlevel9k/powerlevel9k.zsh-theme
export POWERLEVEL9K_MODE="nerdfont-complete"
export POWERLEVEL9K_PROMPT_ON_NEWLINE=true
export POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

#-------------------------------------------------------------------------------
# Uncomment the following line to use case-sensitive completion.
#-------------------------------------------------------------------------------

# CASE_SENSITIVE="true"

#-------------------------------------------------------------------------------
# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
#-------------------------------------------------------------------------------

# HYPHEN_INSENSITIVE="true"

#-------------------------------------------------------------------------------
# Uncomment the following line to disable bi-weekly auto-update checks.
#-------------------------------------------------------------------------------

# DISABLE_AUTO_UPDATE="true"

#-------------------------------------------------------------------------------
# Uncomment the following line to change how often to auto-update (in days).
#-------------------------------------------------------------------------------

export UPDATE_ZSH_DAYS=7

#-------------------------------------------------------------------------------
# Uncomment the following line to disable colors in ls.
#-------------------------------------------------------------------------------

DISABLE_LS_COLORS="true"

#-------------------------------------------------------------------------------
# Uncomment the following line to disable auto-setting terminal title.
#-------------------------------------------------------------------------------

# DISABLE_AUTO_TITLE="true"

#-------------------------------------------------------------------------------
# Uncomment the following line to enable command auto-correction.
#-------------------------------------------------------------------------------

# ENABLE_CORRECTION="true"

#-------------------------------------------------------------------------------
# Uncomment the following line to display red dots whilst waiting for completion.
#-------------------------------------------------------------------------------

COMPLETION_WAITING_DOTS="true"

#-------------------------------------------------------------------------------
# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
#-------------------------------------------------------------------------------

# DISABLE_UNTRACKED_FILES_DIRTY="true"

#-------------------------------------------------------------------------------
# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
#-------------------------------------------------------------------------------

HIST_STAMPS="yyyy-mm-dd"
#-------------------------------------------------------------------------------
# Would you like to use another custom folder than $ZSH/custom?
#-------------------------------------------------------------------------------

# ZSH_CUSTOM=$DOTFILES

#-------------------------------------------------------------------------------
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#-------------------------------------------------------------------------------

plugins=()

#-------------------------------------------------------------------------------
# Set working directories (for rg, fzf, fd searching)
#-------------------------------------------------------------------------------
WORKDIRS=(
  "workspace"
  "lacework"
  "Dropbox"
  "dotfiles"
  "Downloads"
  "Google\ Drive"
);
# Join working dir strings for RipGrep file search (using conditional parameter expansion - https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html)
WORKDIR_PATHS=""
for WORKDIR in "${WORKDIRS[@]}";
do
  WORKDIR_PATHS+="$HOME/${WORKDIR} "
done

#-------------------------------------------------------------------------------
# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
#-------------------------------------------------------------------------------
files=(
    "$DOTFILES/.path"
    "$DOTFILES/.export"
    "$DOTFILES/.aliases"
    "$DOTFILES/.functions"
    "$DOTFILES/.extra"
    );

for file in "${files[@]}"; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;

unset files file;

#-------------------------------------------------------------------------------
# Add Pyenv functionality to ZSH shell + pyenv setup
# Also install pipsi, pipenv
#-------------------------------------------------------------------------------
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

#-------------------------------------------------------------------------------
# Initialize fasd for fast FS navigation
#-------------------------------------------------------------------------------
eval "$(fasd --init auto)"

#-------------------------------------------------------------------------------
# Hook direnv binary to shell so it activates on each directory change
#-------------------------------------------------------------------------------
eval "$(direnv hook zsh)"

#-------------------------------------------------------------------------------
# [Lacework] activate dev env
#-------------------------------------------------------------------------------
# Check if command exists before source
if type "lwenv" > /dev/null; then
  source lwenv dev2
fi

#-------------------------------------------------------------------------------
# Activate Oh-My-Zsh
#-------------------------------------------------------------------------------
source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
