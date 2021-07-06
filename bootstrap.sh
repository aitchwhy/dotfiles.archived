# -------------------------------------------------
# Check for Homebrew and install if we don't have it
# -------------------------------------------------
echo "Install brew if not exist"
if test ! $(which brew); then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

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
# Update Homebrew recipes
# -------------------------------------------------
echo "Brew update"
brew update

# -------------------------------------------------
# Install all our dependencies with bundle (See Brewfile)
# -------------------------------------------------
echo "Install all Brewfile dependencies in bundle"
brew tap homebrew/bundle
brew bundle --file=$DOTFILES/Brewfile # Install binary & applications
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
# Config files linked (home -> dotfiles)
# -------------------------------------------------
echo "Symlink all config dotfiles to home"

# Zsh configs linked
ln -nfs $DOTFILES/.zshrc $HOME/.zshrc

# Vim configs linked
ln -nfs $DOTFILES/.vimrc $HOME/.vimrc

# tmux config files linked
ln -nfs $DOTFILES/.tmux.conf $HOME/.tmux.conf

# Direnv link (env vars per project)
ln -nfs $DOTFILES/.direnvrc $HOME/.direnvrc

# dir colors (zsh color config)
ln -nfs $DOTFILES/.dir_colors $HOME/.dir_colors

# Doom directory
ln -nfs $DOTFILES/.doom.d $HOME/.doom.d

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
# Install python stuff (pyenv, pipsi, pipenv)
# -------------------------------------------------
echo "Install Python util binaries"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# -------------------------------------------------
# Source profile
# -------------------------------------------------
echo "Source ZSHRC"
source $HOME/.zshrc
