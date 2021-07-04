# -------------------------------------------------
# Set temporary variable
# -------------------------------------------------

CODE_DIR=$HOME/workspace
GIT_USER_NAME="hdd2k"
GIT_EMAIL="hank.lee.qed@gmail.com"
DOTFILES=$HOME/dotfiles

# -------------------------------------------------
# Check for Homebrew and install if we don't have it
# -------------------------------------------------

if test ! $(which brew); then
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# -------------------------------------------------
# Update brew Cellar filepath permissions to write to it
# -------------------------------------------------
sudo chown -R $(whoami) $(brew --prefix)/*

# -------------------------------------------------
# Add zsh to standard shells
# -------------------------------------------------
echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells

# -------------------------------------------------
# create neovim config (init <- vimrc)
# -------------------------------------------------
mkdir -p $HOME/.config/nvim
ln -nfs $DOTFILES/.vimrc ~/.config/nvim/init.vim

# -------------------------------------------------
# Update Homebrew recipes
# -------------------------------------------------
brew update

# -------------------------------------------------
# Install all our dependencies with bundle (See Brewfile)
# -------------------------------------------------
brew tap homebrew/bundle
brew bundle --file=$DOTFILES/Brewfile # Install binary & applications
brew cleanup
brew cask cleanup

# -------------------------------------------------
# Install global Git configuration
# -------------------------------------------------

ln -nfs $DOTFILES/.gitconfig $HOME/.gitconfig
git config --global core.excludesfile $DOTFILES/.gitignore_global
git config --global user.name "${GIT_USER_NAME}"
git config --global user.email "${GIT_EMAIL}"

# -------------------------------------------------
# Make ZSH the default shell environment
# -------------------------------------------------

chsh -s $(which zsh)

#-------------------------------------------------------------------------------
# Install Oh-my-zsh
#-------------------------------------------------------------------------------

sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# Install Powerline theme
wget https://raw.githubusercontent.com/jeremyFreeAgent/oh-my-zsh-powerline-theme/master/powerline.zsh-theme -O $HOME/.oh-my-zsh/themes/powerline.zsh-theme
git clone git@github.com:powerline/fonts.git && bash fonts/install.sh
sleep 3
rm -rf fonts

# -------------------------------------------------
# Config files linked (home -> dotfiles)
# -------------------------------------------------

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
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# -------------------------------------------------
# Git - global
# -------------------------------------------------

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
pip3 install pynvim

# -------------------------------------------------
# Install Langauge server
# -------------------------------------------------

# Javascript
npm install -g javascript-typescript-langserver
# Python
pip3 install python-language-server

# -------------------------------------------------
# FZF additional install (fuzzy completion + key-bindings)
# -------------------------------------------------
$(brew --prefix)/opt/fzf/install

# -------------------------------------------------
# Install python stuff (pyenv, pipsi, pipenv)
# -------------------------------------------------
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# -------------------------------------------------
# Source profile
# -------------------------------------------------
source $HOME/.zshrc
