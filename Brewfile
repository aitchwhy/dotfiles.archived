#-------------------------------------------------------------------------------
# Taps
#-------------------------------------------------------------------------------

tap 'caskroom/cask'
tap 'caskroom/fonts'
tap 'homebrew/php'
tap 'homebrew/services'

#-------------------------------------------------------------------------------
# Make sure apps get installed in system Applications dir
#-------------------------------------------------------------------------------

cask_args appdir: '/Applications'

#-------------------------------------------------------------------------------
# Install ZSH
#-------------------------------------------------------------------------------

brew 'zsh'
brew 'zsh-completions'

#-------------------------------------------------------------------------------
# Install GNU core utilities (those that come with OS X are outdated)
#-------------------------------------------------------------------------------

brew 'coreutils'

#-------------------------------------------------------------------------------
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
#-------------------------------------------------------------------------------

brew 'findutils'

#-------------------------------------------------------------------------------
# Install Bash 4
#-------------------------------------------------------------------------------

brew 'bash'

#-------------------------------------------------------------------------------
# Install Binaries
#-------------------------------------------------------------------------------

brew 'direnv'
brew 'grep'
brew 'parallel'
brew 'aws-elasticbeanstalk'
brew 'awslogs'
brew 'git'
brew 'git-flow'
brew 'htop'
brew 'httpie'
brew 'hub'
brew 'node@6', args: ['with-full-icu', 'with-npm']
brew 'openssl'
brew 'tcpdump'
brew 'tree'
brew 'wget'
brew 'fzf'
brew 'ag'
brew 'cmake'

#-------------------------------------------------------------------------------
# Development-PHP
# @see $ brew info php71, which reads...
# With the release of macOS Sierra the Apache module is now not built by default.
# If you want to build it on your system you have to install php with the
# --with-httpd24 option. See  brew options php71  for more details.
#-------------------------------------------------------------------------------

brew 'php71' #, args: ['without-apache']
brew 'php71-intl'
brew 'php71-redis'
brew 'php71-xdebug'
brew 'phpdocumentor'
brew 'composer'
brew 'phpunit'
brew 'php-cs-fixer'

#-------------------------------------------------------------------------------
# Development-Ruby
#-------------------------------------------------------------------------------

brew 'ruby'
brew 'rbenv'

#-------------------------------------------------------------------------------
# Development-Python (includes pip, easy_install)
# ... Also jupyter for jupyter notebook
#-------------------------------------------------------------------------------

brew 'python', args:['with-sphinx-doc']
brew 'python3', args:['with-sphinx-doc']
brew 'pyenv'
brew 'pyenv-virtualenv'
brew 'jupyter'

#-------------------------------------------------------------------------------
# Development-Go
#-------------------------------------------------------------------------------

brew 'golang'

#-------------------------------------------------------------------------------
# Development-Java
#-------------------------------------------------------------------------------

cask 'java'
brew 'gradle'
brew 'kotlin'

#-------------------------------------------------------------------------------
# Development-Database
#-------------------------------------------------------------------------------

brew 'mysql'
brew 'sqlite'

#-------------------------------------------------------------------------------
# Apps
#-------------------------------------------------------------------------------

cask 'mactex'
cask 'cheatsheet'
cask 'ngrok'
cask 'anaconda'
cask 'docker'
cask 'google-chrome'
cask 'iterm2'
cask 'psequel'
cask 'rdm'
cask 'sequel-pro'
cask 'sublime-text'
cask 'wireshark'
cask 'alfred'
cask 'mosaic'
cask 'istat-menus'
cask 'slack'
cask 'postman'
cask 'keyboard-maestro'
cask 'flux'
cask 'dropbox'

#-------------------------------------------------------------------------------
# Fonts
#-------------------------------------------------------------------------------

cask 'font-source-code-pro'
