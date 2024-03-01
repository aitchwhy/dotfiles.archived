# dotfiles

Environment setup files for OSX setup

TODOS

## 0. Hardware setup

- update modifier keys (e.g. Caps lock -> Ctrl)
- enable key hold [link](https://www.macworld.com/article/351347/how-to-activate-key-repetition-through-the-macos-terminal.html)

```
defaults write -g ApplePressAndHoldEnabled -bool false
```

## 1. Xcode Installation + other App Store apps

Install Brew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Need to install Xcode CLI tools.  Install them from the App Store

After installation, run the following command in the shell

```bash
~ $ sudo xcodebuild -license accept # License agreement (accept all)
~ $ xcode-select --install   # Command Line Tool installation
```

## 2. SSH setup

Generate appropriate SSH key pairs on Github (or other repository service)

[Github SSH help link](https://help.github.com/articles/connecting-to-github-with-ssh/)

## 3. Install dotfiles setup

Make sure the dotfiles directory is downloaded to $HOME directory

## 4. Run dotfiles setup

Open necessary files to update correct Git user info

```bash
# ~/dotfiles/scripts/.extra.sh <--- copy afresh from .extra.sh.template

WORKSPACE_ROOT=$HOME/workspace
GIT_USER_NAME="foo"
GIT_EMAIL="foo@bar.com"
```

Run dotfiles setup script

```bash
~/dotfiles $ bash bootstrap.sh
```

## 5. Iterm2 setup

### Change iterm2 font to one that supports Powerline

Install Google Material color scheme for Iterm2 (or whichever color preset you'd like)

- [Google's Material Design Color Palette for Iterm2](https://github.com/MartinSeeler/iterm2-material-design)

### Update iTerm2 key for FZF

- (Pref -> Profiles -> Keys -> Left Option Key = Esc+)

## App Store setup (listed in Brewfile as 'mas' deps)

- [mas CLI (for Mac App Store)](https://github.com/mas-cli/mas)

## main tools configuration setup

### Vim

- install Vim plugins (in .vimrc) by entering vim in shell, and then ":PlugInstall"

### Python (installed by Brewfile)

- [pyenv](https://github.com/pyenv/pyenv) ---> shoudl be installed by Homebrew

```shell
pyenv install 3.10 # installs python version (3.10)
pyenv versions # list installed python versions
pyenv global 3.10 # set global default version
```

### Node/nvm (nvm installed by Brewfile)

- nvm install global version

```shell
$ nvm install node # installs latest "node" version
$ nvm ls
$ nvm alias default node # set global default version
# ...
$ nvm use node # specify a version of node to use now
```

### VSCode

- login to Github user for settings sync
- most custom changes are in Bear notes tag "vscode"

### Datagrip

- login to Jetbrains user for settings sync
- most custom changes are in Bear notes tag "datagrip"

### Direnv

- [Automatically Activate env - Direnv](https://direnv.net/)
