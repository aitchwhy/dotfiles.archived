# Homebrew Brewfile docs -> https://homebrew-file.readthedocs.io/en/latest/usage.html

#-------------------------------------------------------------------------------
# Taps
#-------------------------------------------------------------------------------

tap 'homebrew/cask'
tap 'homebrew/cask-fonts'
tap 'homebrew/services'
tap 'romkatv/powerlevel10k'
tap 'ngrok/ngrok'

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
# Mac App store CLI (https://github.com/mas-cli/mas)
#-------------------------------------------------------------------------------
brew 'mas'

#-------------------------------------------------------------------------------
# Install Binaries
#------------------------------------------------------------------------------

brew 'ripgrep'                                   # fast search
brew 'fd'                                        # Upgrade to 'find'
brew 'sd'                                        # Upgrade to 'sed'
brew 'git-delta'                                 # Upgrade to 'diff'
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
brew 'zoxide'                                    # Filesystem Navigation
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
brew 'jc' # CLI JSON converter + other useful conversions CLI tool
brew 'rsync'

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

brew 'java'
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
cask '1password-cli' # 1password CLI
cask 'devutils' # devutils (~50 various dev utils like cron parser, uuid generator, etc)
cask 'ngrok' # ingress-as-a-service (easiest way to expose localhost to public internet)


#-------------------------------------------------------------------------------
# Mac App store downloads into Brewfile (Uses Mac App store CLI - https://github.com/mas-cli/mas).
# The line is like:
# mas "App Name", id: 123456789 (get ID from `$ mas list`)
#-------------------------------------------------------------------------------

# Magnet (window sizing)
mas "Magnet", id: 441258766
mas "KakaoTalk", id: 869223134
mas "Bear", id: 1091189122
mas "TestFlight", id: 899247664
mas "Omnivore", id: 1564031042
mas "Slack", id: 803453959
mas "The Unarchiver", id: 425424353
mas "Xcode", id: 497799835
mas "WhatsApp", id: 1147396723
mas "Bitwarden", id: 1352778147
mas "Toggl Track", id: 1291898086
mas "Human Japanese", id: 412213489
