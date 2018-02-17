# dotfiles

Environment setup files for OSX setup

## 1. Xcode Installation + other App Store apps

Need to install Xcode CLI tools.  Install them from the App Store

After installation, run the following command in the shell

```bash
~ $ sudo xcodebuild -license # License agreement
~ $ xcode-select --install   # Command Line Tool 설치installation
```

## 2. SSH setup

Generate appropriate SSH key pairs on Github (or other repository service)

[Github SSH help link](https://help.github.com/articles/connecting-to-github-with-ssh/)

## 3. Install dotfiles setup

Make sure the dotfiles directory is downloaded to HOME directory

## 4. Run dotfiles setup

Open necessary files to update correct Git user info

```bash
# ~/dotfiles/bootstrap.sh

CODE_DIR=$HOME/workspace
GIT_USER_NAME="foo"
GIT_EMAIL="foo@bar.com"
```

Run dotfiles setup script

```bash
~/dotfiles $ bash bootstrap.sh
```

Setup Autoenv
```bash
~/dotfiles $ echo "source $(brew --prefix autoenv)/activate.sh" >> ~/.zshrc
```

## 5. Iterm2 setup

Change iterm2 font to one that supports Powerline

Install Google Material color scheme for Iterm2
- [Google's Material Design Color Palette for Iterm2](https://github.com/MartinSeeler/iterm2-material-design)


## References
- [Copied off of Mesh dotfiles](https://github.com/meshkorea/prime-utility/tree/master/dotfiles)
- [David Culley - Installing software](https://www.davidculley.com/installing-software-via-homebrew/)
- [David Culley - Setting up Python env](https://www.davidculley.com/installing-python-on-a-mac/)
- [Python + Conda workflow](https://tdhopper.com/blog/my-python-environment-workflow-with-conda/)
- [Automatically Activate env - AutoEnv](https://github.com/kennethreitz/autoenv)
