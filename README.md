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

Make sure the dotfiles directory is downloaded to $HOME directory

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


## Notes

### Python environment setup

*python, pip, virtualenv*

- [pyenv](https://github.com/pyenv/pyenv)
    - Manages + installs (global / local) Python versions (+pip)
- [pipsi](https://github.com/mitsuhiko/pipsi)
    - PIP Script Installer (pipsi)
    - Wrapper(virtualenv, pip) ---> Separate virtualenv installs for Python-based-CLI programs (ex: awscli, pipenv, etc)
    - Bugs! (02/23/18)
        - [pipsi fails - no 'virtualenv' file](https://github.com/mitsuhiko/pipsi/issues/125)
            - Must install using `master` branch
            - `$ python get-pipsi.py --src=git+https://github.com/mitsuhiko/pipsi.git#egg=pipsi`
        - [pipsi list fails - no 'package_info.json'](https://github.com/mitsuhiko/pipsi/issues/124)
            - Edit pipsi virtualenvs file
- [pipenv](https://github.com/pypa/pipenv)
    - Python Packaging tool
    - pip + virtualenv used together!
    - Hashes everywhere for security
    - Pipfile.lock ensures deterministic builds
    - Shows Dependency graph ($ pipenv graph)

*data science libraries*

- pipenv install tensorflow
- pipenv install keras

## Helpful References
- [Copied off of Mesh dotfiles](https://github.com/meshkorea/prime-utility/tree/master/dotfiles)
- [Python Environment Setup](https://jacobian.org/writing/python-environment-2018/)
- [Automatically Activate env - Direnv](https://direnv.net/)
