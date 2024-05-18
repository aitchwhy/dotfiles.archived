#-------------------------------------------------------------------------------
# Path to your dotfiles installation.
#-------------------------------------------------------------------------------
export DOTFILES=$HOME/dotfiles

#-------------------------------------------------------------------------------
# Path to Dropbox root folder (real-time synced)
#-------------------------------------------------------------------------------
export DROPBOX=$HOME/Library/CloudStorage/Dropbox

#-------------------------------------------------------------------------------
# Path to oh-my-zsh installation
#-------------------------------------------------------------------------------
export ZSH=$HOME/.oh-my-zsh

#-------------------------------------------------------------------------------
# Preferred editor for local and remote sessions
#-------------------------------------------------------------------------------
export EDITOR='nvim'

#-------------------------------------------------------------------------------
# Compilation flags
#-------------------------------------------------------------------------------

# export ARCHFLAGS="-arch x86_64"

#-------------------------------------------------------------------------------
# Status prompt configuration (powerlevel9k) - https://github.com/Powerlevel9k/powerlevel9k
# Defaults for left + right are below
#-------------------------------------------------------------------------------

export POWERLEVEL9K_CUSTOM_KUBE_PS1='kube_ps1'
# export POWERLEVEL9K_CONTEXT_TEMPLATE="(context dir vcs custom_kube_ps1)"
export POWERLEVEL9K_CONTEXT_TEMPLATE="%n@"
export POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs custom_kube_ps1)
# export POWERLEVEL9K_CONTEXT_TEMPLATE="(context dir vcs custom_kube_ps1)"
# export POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS="(status root_indicator background_jobs history time)"

export POWERLEVEL9K_MODE="nerdfont-complete"
export POWERLEVEL9K_PROMPT_ON_NEWLINE=true
export POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

#-------------------------------------------------------------------------------
# FZF settings
#-------------------------------------------------------------------------------
# Default settings for CLI fuzzy finder
# https://github.com/junegunn/fzf?tab=readme-ov-file#key-bindings-for-command-line
#
# - m : multi-select with TAB
# - layout=reverse : filter prompt on TOP not bottom
# - inline-info : filtered result count shown INLINE with filter prompt
# - border : draw border around fuzzy finder
# - bind : bind keys WHILE in FZF to execute without leaving FZF
#
# NOTE: {} is replaced with the single-quoted string of the focused line
# NOTE: "alt" == "option" key in Mac
#
# - Press F1 to open the file with less without leaving fzf
# - Press CTRL-Y to copy the line to clipboard and aborts fzf (requires pbcopy)
#   --bind 'f1:execute(less -f {}),ctrl-y:execute-silent(echo {} | pbcopy)+abort'
#-------------------------------------------------------------------------------

# echo "fzf settings : $DOTFILES/scripts/.functions.sh --- FZF_DEFAULT_COMMAND $FZF_DEFAULT_COMMAND"
# echo "fzf settings : $DOTFILES/scripts/.functions.sh --- FZF_DEFAULT_OPTS $FZF_DEFAULT_OPTS"

source $DOTFILES/scripts/.functions.sh
# TODO: ripgrep_fzf_search_file() from .functions.sh

# export FZF_DEFAULT_COMMAND="rg --no-ignore-vcs --hidden --files $WORKDIR_PATHS"
export FZF_DEFAULT_COMMAND="fd . $HOME"
# export FZF_DEFAULT_COMMAND="fd --hidden --no-ignore --type file --files $WORKDIR_PATHS"
export FZF_DEFAULT_OPTS="
  --multi
  --layout=reverse
  --inline-info
  --border"

#########################
#########################
# Ctrl+t -> FILES-only search and paste into CLI
#########################
#########################
# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_COMMAND="rg --no-ignore-vcs --hidden --files $WORKDIR_PATHS"
# FZF_CTRL_T_OPTS to ADD ADDITIONAL options if desired
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
  --header 'Paste selected into shell CLI. All files (rg)'"
#########################
#########################
# Ctrl+r -> shell command history (zsh) search and paste into CLI
# NOTE: press Ctrl+r again to SORT toggle (relevance + time)
# NOTE: "alt" == "option" key in Mac
#########################
#########################
# FZF_CTRL_R_OPTS if we want more options (ADDITIONAL) for Ctrl+r
# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
--preview 'echo {}' --preview-window up:3:hidden:wrap
--bind 'ctrl-/:toggle-preview'
--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
--color header:italic
--header 'Paste selected Shell command. Press CTRL-Y to copy command into clipboard'"
#########################
# Esc+c -> search and CD into directory
# NOTE: updated at iTerm2 level to use "Esc" as "Option" -> https://github.com/junegunn/fzf/issues/164
# NOTE: press Ctrl+r again to SORT toggle (relevance + time)
#########################
# FZF_ALT_C_COMMAND -> to override Alt+c command
# FZF_ALT_C_OPTS -> to pass ADDITIONAL Alt+c options
export FZF_ALT_C_COMMAND="fd -t d . $HOME"
# Print tree structure (-C means "colored") in the preview window
export FZF_ALT_C_OPTS="--preview 'tree -C {}'"
#########################

#-------------------------------------------------------------------------------
# For brew cask available options
# @see. https://github.com/caskroom/homebrew-cask/blob/master/USAGE.md#options
#-------------------------------------------------------------------------------
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

#-------------------------------------------------------------------------------
# Export language settings
#-------------------------------------------------------------------------------
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

#-------------------------------------------------------------------------------
# (workaround) pyenv 'gettext' error - shims do not work with gettext
#-------------------------------------------------------------------------------
export GIT_INTERNAL_GETTEXT_TEST_FALLBACKS=1

#-------------------------------------------------------------------------------
# Zlib flag export (Pyenv install 'zlib not found' error)
#-------------------------------------------------------------------------------

# For compilers to find zlib you may need to set:
export LDFLAGS="${LDFLAGS} -L/usr/local/opt/zlib/lib"
export CPPFLAGS="${CPPFLAGS} -I/usr/local/opt/zlib/include"

# For pkg-config to find zlib you may need to set:
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH} /usr/local/opt/zlib/lib/pkgconfig"

#-------------------------------------------------------------------------------
# Javascript (Node, Deno, etc)
#-------------------------------------------------------------------------------
export DENO_INSTALL="$HOME/.deno"

#-------------------------------------------------------------------------------
# Tmux fzf gnu-sed (gsed) path
#-------------------------------------------------------------------------------
export TMUX_FZF_SED="/usr/local/bin/gsed"

#-------------------------------------------------------------------------------
# Justfile
#-------------------------------------------------------------------------------
export USER_JUSTFILE_NAME=".user.justfile"
export USER_JUSTFILE_PATH="~/.user.justfile"

#-------------------------------------------------------------------------------
# Python + Pyenv setup
#-------------------------------------------------------------------------------
# No __pycache__
# export PYTHONDONTWRITEBYTECODE=1
# export PYENV_ROOT=$HOME/.pyenv

#-------------------------------------------------------------------------------
# Sqlite DB setup (Homebrew version)
#
# See Brewfile 'sqlite' comments for more info
#-------------------------------------------------------------------------------
# For compilers to find sqlite you may need to set:
export LDFLAGS="-L$BREW_PREFIX/opt/sqlite/lib"
export CPPFLAGS="-I$BREW_PREFIX/opt/sqlite/include"
# For pkg-config to find sqlite you may need to set:
export PKG_CONFIG_PATH="$BREW_PREFIX/opt/sqlite/lib/pkgconfig"
