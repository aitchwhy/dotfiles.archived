# Custom function to adding valid directories (dir exists, non-duplicate)
# https://superuser.com/questions/39751/add-directory-to-path-if-its-not-already-there
pathadd() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1" # append
        #PATH="$1${PATH:+":$PATH"}" # prepend
    fi
}

#-------------------------------------------------------------------------------
# Use project specific binaries before global ones
#-------------------------------------------------------------------------------
pathadd "node_modules/.bin:vendor/bin"
# PATH="node_modules/.bin:vendor/bin:$PATH"

#-------------------------------------------------------------------------------
# Add M1 homebrew prefix
#-------------------------------------------------------------------------------
pathadd "$BREW_PREFIX/bin"

#-------------------------------------------------------------------------------
# Make sure coreutils are loaded before system commands
#-------------------------------------------------------------------------------

pathadd "$BREW_PREFIX/opt/coreutils/libexec/gnubin"

#-------------------------------------------------------------------------------
# Javascript (Deno, etc)
#-------------------------------------------------------------------------------
pathadd "$HOME/.deno/bin"

#-------------------------------------------------------------------------------
# Sqlite DB setup (Homebrew version)
#
# See Brewfile 'sqlite' comments for more info
#-------------------------------------------------------------------------------
pathadd "$BREW_PREFIX/opt/sqlite/bin"

#-------------------------------------------------------------------------------
# Local bin directories before anything else
#-------------------------------------------------------------------------------
pathadd "/usr/local/bin:/usr/local/sbin"
# PATH="/usr/local/bin:/usr/local/sbin:$PATH"

#-------------------------------------------------------------------------------
# Load custom commands
#-------------------------------------------------------------------------------
pathadd "$DOTFILES/bin"

#-------------------------------------------------------------------------------
# pipsi paths
#-------------------------------------------------------------------------------
pathadd "$HOME/.local/bin"

#-------------------------------------------------------------------------------
# dotfiles scripts
#-------------------------------------------------------------------------------
pathadd "$HOME/dotfiles/scripts"


#-------------------------------------------------------------------------------
# Emacs binaries
#-------------------------------------------------------------------------------
pathadd "$HOME/.emacs.d/bin"

#-------------------------------------------------------------------------------
# Golang (homebrew go binaries M1+)
#-------------------------------------------------------------------------------
pathadd "$GOPATH/bin"
pathadd "$BREW_PREFIX/opt/go/bin"

#-------------------------------------------------------------------------------
# tgswitcher (Terragrunt switcher) setup  - https://github.com/warrensbox/tgswitch
# (related to Terraform)
#-------------------------------------------------------------------------------
pathadd "$HOME/bin"
