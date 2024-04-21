# -------------------------------------------------
# Install Nix (https://nixos.org/manual/nix/stable/installation/)
# -------------------------------------------------
source $DOTFILES/scripts/nix_helpers.sh
nix_init

# -------------------------------------------------
# Check for Homebrew and install if we don't have it
# -------------------------------------------------
echo "Install brew if not exist"
if test ! $(which brew); then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# create shell env var for brew prefix path since (brew --prefix) is too slow (0.5 ~ 0.8 sec)
export BREW_PREFIX=$(brew --prefix)

# -------------------------------------------------
# Set temporary variables (from .extra <- created from .extra.template)
# -------------------------------------------------
echo "Exporting env vars for per-machine config"
source "$HOME/dotfiles/scripts/.extra.sh"

# -------------------------------------------------
# Update brew Cellar filepath permissions to write to it
# -------------------------------------------------
echo "Update Brew cellar filepath permissions to write"
sudo chown -R $(whoami) $BREW_PREFIX/*

# -------------------------------------------------
# Add zsh to standard shells
# -------------------------------------------------
echo "Add ZSH to standard shells"
echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells

# -------------------------------------------------
# create neovim config (init <- vimrc)
# -------------------------------------------------
echo "Create neovim config"
mkdir -p $HOME/.config/nvim
ln -nfs $DOTFILES/.vimrc ~/.config/nvim/init.vim

# -------------------------------------------------
# create shell GPT config folder (https://github.com/TheR1D/shell_gpt)
# -------------------------------------------------
echo "Create shell_gpt config"
mkdir -p $HOME/.config/shell_gpt/.sgptrc
ln -nfs $DOTFILES/.sgptrc $HOME/.config/shell_gpt/.sgptrc

# -------------------------------------------------
# Update Homebrew recipes
# -------------------------------------------------
echo "Brew update --- setup brew to master branch in case something is misconfigured"
git -C $(brew --repository homebrew/core) checkout master
brew update

# -------------------------------------------------
# Install all our dependencies with bundle (See Brewfile)
# -------------------------------------------------
echo "Install all Brewfile dependencies in bundle"
brew tap homebrew/bundle
brew bundle --file=$DOTFILES/Brewfile # Install binary & applications
# Nerd font dynamic install all - https://gist.github.com/davidteren/898f2dcccd42d9f8680ec69a3a5d350e
brew search '/font-.*-nerd-font/' | awk '{ print $1 }' | xargs -I{} brew install --cask {} || true
brew cleanup
brew cask cleanup

# -------------------------------------------------
# Install global Git configuration
# -------------------------------------------------
echo "Install all Global Git config"
ln -nfs $DOTFILES/.gitconfig $HOME/.gitconfig
git config --global core.excludesfile $DOTFILES/.gitignore_global
git config --global user.name "${GIT_USER_NAME}"
git config --global user.email "${GIT_EMAIL}"

# -------------------------------------------------
# Make ZSH the default shell environment
# - https://rick.cogley.info/post/use-homebrew-zsh-instead-of-the-osx-default/
# -------------------------------------------------

echo "Make ZSH the default shell (the homebrew installation Zsh path)"
# we want default homebrew Zsh : /opt/homebrew/bin/zsh (for M1 versions)
source $DOTFILES/scripts/.functions.sh
set_user_shell $BREW_PREFIX/bin/zsh

#-------------------------------------------------------------------------------
# Install Oh-my-zsh
#-------------------------------------------------------------------------------
echo "Install Oh-my-zsh"
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# Install Powerline theme
wget https://raw.githubusercontent.com/jeremyFreeAgent/oh-my-zsh-powerline-theme/master/powerline.zsh-theme -O $HOME/.oh-my-zsh/themes/powerline.zsh-theme
git clone git@github.com:powerline/fonts.git && bash fonts/install.sh
sleep 3
rm -rf fonts

# Install Zsh custom plugins (e.g. Zsh history database 'zsh-histdb')
# https://github.com/larkery/zsh-histdb?tab=readme-ov-file#installation
mkdir -p $HOME/.oh-my-zsh/custom/plugins/
git clone https://github.com/larkery/zsh-histdb $HOME/.oh-my-zsh/custom/plugins/zsh-histdb

# -------------------------------------------------
# Config files linked
# -------------------------------------------------
echo "Symlink all config dotfiles"
source $DOTFILES/scripts/symlinks_config.sh
create_sudo_symlinks

# -------------------------------------------------
# Install vim plugin manager (vim-plug)
# -------------------------------------------------
echo "Install Vim plugin manager"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# -------------------------------------------------
# Git - global
# -------------------------------------------------

echo "NPM global installs"
npm install --global git-open

# -------------------------------------------------
# Install global Node packages
# -------------------------------------------------

# yarn package manager
npm install -g yarn

# -------------------------------------------------
# Pip installs
# -------------------------------------------------
# Python client for Neovim
echo "PIP global installs"
pip3 install pynvim
pip3 install shell-gpt # shell-gpt==0.9.0

# -------------------------------------------------
# Install Langauge server
# -------------------------------------------------
echo "Install language server (LSP)"

# Javascript
npm install -g javascript-typescript-langserver
# Python
pip3 install python-language-server

# -------------------------------------------------
# FZF additional install (fuzzy completion + key-bindings)
# -------------------------------------------------
echo "Install FZF additional"
$BREW_PREFIX/opt/fzf/install

# -------------------------------------------------
# Secrets management
# Create secrets file (should be manually populated)
# -------------------------------------------------
echo "Add template file for secrets"
echo "export ENV_VAR=foobar" >$DOTFILES/scripts/secrets.sh

# -------------------------------------------------
# Install python stuff (pyenv, pipsi, pipenv) + global setup
# -------------------------------------------------
echo "Install Python util binaries"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Set global python version (TODO: update this to use global venv (?) pyenv accepts virtualenv names as well)
# pyenv global 3.10.12
# Install global env python packages

# -------------------------------------------------
# Source profile
# -------------------------------------------------
echo "Source ZSHRC"
source $HOME/.zshrc
