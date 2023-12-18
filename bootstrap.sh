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
source "$HOME/dotfiles/.extra"

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
# -------------------------------------------------

echo "Make ZSH the default shell"
chsh -s $(which zsh)

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

# -------------------------------------------------
# Config files linked
# -------------------------------------------------
echo "Symlink all config dotfiles"
source $DOTFILES/symlinks_config.sh
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
echo "export ENV_VAR=foobar" >$DOTFILES/secrets.sh

# -------------------------------------------------
# Install python stuff (pyenv, pipsi, pipenv) + global setup
# -------------------------------------------------
echo "Install Python util binaries"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Set global python version
pyenv global 3.10.12
# Install global python binaries
pip install git-remote-dropbox

# -------------------------------------------------
# Source profile
# -------------------------------------------------
echo "Source ZSHRC"
source $HOME/.zshrc
