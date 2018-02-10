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

# Install cobalt2 theme
# wget https://raw.githubusercontent.com/wesbos/Cobalt2-iterm/master/cobalt2.zsh-theme -O $HOME/.oh-my-zsh/themes/cobalt2.zsh-theme

# Install Powerline theme
wget https://raw.githubusercontent.com/jeremyFreeAgent/oh-my-zsh-powerline-theme/master/powerline.zsh-theme -O $HOME/.oh-my-zsh/themes/powerline.zsh-theme
git clone git@github.com:powerline/fonts.git && bash fonts/install.sh
sleep 3
rm -rf fonts

#-------------------------------------------------------------------------------
# Install & execute profile
#-------------------------------------------------------------------------------

ln -nfs $DOTFILES/.zshrc $HOME/.zshrc

#-------------------------------------------------------------------------------
# Install .vimrc
#-------------------------------------------------------------------------------

ln -nfs $DOTFILES/.vimrc $HOME/.vimrc

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
# Install Laravel Valet
# IMPORTANT NOTE
# For valet to work correctly, php71 & nginx must be run as sudo privileges.
# # brew services start php71 && brew services nginx
#-------------------------------------------------------------------------------

$HOME/.composer/vendor/bin/valet install
cd $HOME/$CODE_DIR && $HOME/.composer/vendor/bin/valet park

#-------------------------------------------------------------------------------
# Install Homestead Repo & Add vagrant box
# Commented out on behalf of Docker
#-------------------------------------------------------------------------------

# git clone git@github.com:laravel/homestead.git $HOME/Homestead
# cd $HOME/Homestead && bash ./init.sh
# [[ $(basename $(pwd)) != "Homestead" ]] && cd $HOME/Homestead; vagrant box add laravel/homestead

#-------------------------------------------------------------------------------
# Install global Node packages
#-------------------------------------------------------------------------------

npm install gulp-cli gulp yo http-server nodemon yarn --global --save

#-------------------------------------------------------------------------------
# Install Rails
#-------------------------------------------------------------------------------

# gem install rails

#-------------------------------------------------------------------------------
# Source profile
#-------------------------------------------------------------------------------

source $HOME/.zshrc
