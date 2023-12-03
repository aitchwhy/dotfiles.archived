#-------------------------------------------------------------------------------
# Taps
#-------------------------------------------------------------------------------

tap 'homebrew/cask'
tap 'homebrew/cask-fonts'
tap 'homebrew/services'
tap 'romkatv/powerlevel10k'

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
#------------------------------------------------------------------------------

brew 'ripgrep'                                   # fast search
brew 'fd'                                        # Upgrade to 'find'
brew 'sd'                                        # Upgrade to 'sed'
brew 'delta'                                     # Upgrade to 'diff'
brew 'tldr'                                      # Simplified to 'man' pages
brew 'dust'                                      # Upgrade to 'du'
brew 'eza'                                       # modern 'ls'
brew 'graphviz'                                  # Graph visualizations
brew 'diff-so-fancy'                             # 'diff' upgrade for Git usage
brew 'bat'                                       # 'cat' upgrade
brew 'ctags'                                     # tags for Project navigation
brew 'nginx'                                     # web server
brew 'dnsmasq'                                   # lightweight DNS forwarder + DHCP server
brew 'prettyping'                                # Pretty ping (simple, colorized output)
brew 'tmux'                                      # terminal multiplexing
brew 'fasd'                                      # Navigation
brew 'mutt'                                      # CLI email util (for crontab)
brew 'jq'                                        # CLI JSON manipulator
brew 'fx'                                        # CLI JSON editor
brew 'cscope'                                    # Ctags complement for tagged code
brew 'direnv'
brew 'grep'
brew 'parallel'
brew 'htop'
brew 'httpie'
brew 'openssl'
brew 'tcpdump'
brew 'tree'
brew 'wget'
brew 'fzf'
brew 'cmake'
brew 'hexyl'                                        # Better 'xxd' (hex code viewer)
brew 'neovim'                                       # Better 'vim'
brew 'zlib'
brew 'powerlevel10k'				                # zsh shell powerline
brew 'git-recent'                                   # viewing latest git branches
brew 'broot'                                        # broot - tree,cd,fuzzy-search
brew 'chrome-cli'
brew 'bitwarden-cli' # password manager CLI

brew 'cfr-decompiler'
brew 'zola'
brew 'httrack' # website download / mirror tool
brew 'ngrok' # ingress-as-a-service (easiest way to expose localhost to public internet)
brew 'devutils' # devutils (~50 various dev utils like cron parser, uuid generator, etc)
brew 'jc' # CLI JSON converter + other useful conversions CLI tool

#-------------------------------------------------------------------------------
# AWS
#-------------------------------------------------------------------------------

brew 'awslogs'
brew 'awscli'

#-------------------------------------------------------------------------------
# Git + Github
#-------------------------------------------------------------------------------

brew 'git'
brew 'git-flow'
brew 'hub'
brew 'gh' # github cli
brew 'act' # local Github Actions (GHA) runner (using docker)

#-------------------------------------------------------------------------------
# Node
#-------------------------------------------------------------------------------

brew 'nvm'                                       # Node version manager

#-------------------------------------------------------------------------------
# terraform + terragrunt
#-------------------------------------------------------------------------------

# Terraform version manager (tfenv) - no need for separate "terraform" brew install with tfenv.
brew 'tfenv'
# Terraform official language server (ls)
brew 'terraform-ls' # Used for VSCode IDE terraform plugin to do Goto Symbol + etc.

# Terragrunt version manager (tgswitch)
brew 'warrensbox/tap/tgswitch'

#-------------------------------------------------------------------------------
# kubernetes
#-------------------------------------------------------------------------------

brew 'kube-ps1'
brew 'kops'
brew 'ksh'

#-------------------------------------------------------------------------------
# Development-Ruby
#-------------------------------------------------------------------------------

brew 'ruby'
brew 'rbenv'

#-------------------------------------------------------------------------------
# Development-Python (includes pip, easy_install)
# ... Also jupyter for jupyter notebook
#-------------------------------------------------------------------------------

brew 'pyenv'
brew 'pyenv-virtualenv'
brew 'jupyter'

#-------------------------------------------------------------------------------
# Development-Go
#-------------------------------------------------------------------------------

brew 'golang'
brew 'golang-migrate' # golang DB migration

#-------------------------------------------------------------------------------
# Development-Java
#-------------------------------------------------------------------------------

cask 'java'
brew 'gradle'
brew 'kotlin'
brew 'maven'

#-------------------------------------------------------------------------------
# Databases
#-------------------------------------------------------------------------------

brew 'postgresql'                                # DBMS
brew 'sqlite'

#-------------------------------------------------------------------------------
# Apps
#-------------------------------------------------------------------------------

cask 'visual-studio-code'
cask 'spotify'
cask 'fantastical'
cask 'docker'
cask 'iterm2'
cask 'wireshark'
cask 'istat-menus'
cask 'slack'
cask 'postman'
cask 'flux'
cask 'dropbox'
cask 'zoom'
cask 'pdf-expert'
cask 'monitorcontrol'
cask 'datagrip' # JetBrains data IDE
cask 'superhuman' # Superhuman email client
cask '1password' # 1password 8

#-------------------------------------------------------------------------------
# Fonts
#-------------------------------------------------------------------------------

cask 'caskroom/fonts/font-hack-nerd-font'
