#!/bin/sh

#-------------------------------------------------------------------------------
# Thanks Maxime Fabre! https://speakerdeck.com/anahkiasen/a-storm-homebrewin
# Thanks Mathias Bynens! https://mths.be/osx
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Set temporary variable
#-------------------------------------------------------------------------------

CODE_DIR=$HOME/workspace
GIT_USER_NAME="hdd2k"
GIT_EMAIL="hank.lee.qed@gmail.com"
DOTFILES=$HOME/dotfiles

#-------------------------------------------------------------------------------
# Check for Homebrew and install if we don't have it
#-------------------------------------------------------------------------------

if test ! $(which brew); then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

#-------------------------------------------------------------------------------
# Update Homebrew recipes
#-------------------------------------------------------------------------------

brew update

#-------------------------------------------------------------------------------
# Install all our dependencies with bundle (See Brewfile)
#-------------------------------------------------------------------------------

brew tap homebrew/bundle
brew bundle --file=$DOTFILES/Brewfile # Install binary & applications
brew cleanup
brew cask cleanup

#-------------------------------------------------------------------------------
# Install global Git configuration
#-------------------------------------------------------------------------------

ln -nfs $DOTFILES/.gitconfig $HOME/.gitconfig
git config --global core.excludesfile $DOTFILES/.gitignore_global
git config --global user.name "${GIT_USER_NAME}"
git config --global user.email "${GIT_EMAIL}"

#-------------------------------------------------------------------------------
# Make ZSH the default shell environment
#-------------------------------------------------------------------------------

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

#-------------------------------------------------------------------------------
# Install oh-my-dir
#-------------------------------------------------------------------------------

# cd $HOME && git clone git@github.com:ajmazurie/oh-my-dir.git && cd ./oh-my-dir && make install
# cd $HOME && rm -rf oh-my-dir

#-------------------------------------------------------------------------------
# Install & execute profile
#-------------------------------------------------------------------------------

ln -nfs $DOTFILES/.zshrc $HOME/.zshrc
ln -nfs $DOTFILES/.zshenv $HOME/.zshrc

#-------------------------------------------------------------------------------
# Install .vimrc
#-------------------------------------------------------------------------------

ln -nfs $DOTFILES/.vimrc $HOME/.vimrc

#-------------------------------------------------------------------------------
# Install .direnv
#-------------------------------------------------------------------------------

ln -nfs $DOTFILES/.direnvrc $HOME/.direnvrc


#-------------------------------------------------------------------------------
# Install Composer
#-------------------------------------------------------------------------------

curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

#-------------------------------------------------------------------------------
# Install global Composer packages
#-------------------------------------------------------------------------------

/usr/local/bin/composer global require laravel/installer laravel/valet

#-------------------------------------------------------------------------------
# Install global Node packages
#-------------------------------------------------------------------------------

# yarn package manager
npm install -g yarn

# hot reloading on file save
npm install -g nodemon

# linting
npm install -g eslint
npm install -g babel-eslint
npm install -g eslint-config-standard
npm install -g eslint-config-standard-react
npm install -g eslint-config-standard-jsx
npm install -g eslint-plugin-react
npm install -g eslint-config-prettier
npm install -g eslint-plugin-prettier
npm install -g prettier
npm install -g standard
npm install -g typescript

# React
npm install -g create-react-app
npm install -g create-react-library
npm install -g react-native-cli


#-------------------------------------------------------------------------------
# Install Pip + setuptools
#-------------------------------------------------------------------------------

sudo easy_install pip

#-------------------------------------------------------------------------------
# Install Rails
#-------------------------------------------------------------------------------

# gem install rails

#-------------------------------------------------------------------------------
# Install python stuff (pyenv, pipsi, pipenv)
#-------------------------------------------------------------------------------
eval "$(pyenv init -)"

# pipsi from github source
curl -O https://raw.githubusercontent.com/mitsuhiko/pipsi/master/get-pipsi.py
python get-pipsi.py --src=git+https://github.com/mitsuhiko/pipsi.git#egg=pipsi
rm get-pipsi.py

# Append pipsi list fail fix workaround
rm $HOME/.local/venvs/pipsi/package_info.json
echo '{"name": "pipsi", "version": "0.10.dev", "scripts": ["/Users/jacobkaplan-moss/.local/bin/pipsi"]}' > $HOME/.local/venvs/pipsi/package_info.json

# pipenv
pipsi install pew
pipsi install pipenv

#-------------------------------------------------------------------------------
# Install Vim-anywhere
#-------------------------------------------------------------------------------
curl -fsSL https://raw.github.com/cknadler/vim-anywhere/master/install | bash

#-------------------------------------------------------------------------------
# Source profile
#-------------------------------------------------------------------------------

source $HOME/.zshrc

