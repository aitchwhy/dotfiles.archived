# Homebrew Brewfile docs
# - https://docs.brew.sh/Manpage#bundle-subcommand
# TODO: Brewfile manager 
# - https://homebrew-file.readthedocs.io/en/latest/usage.html

#-------------------------------------------------------------------------------
# Taps
#-------------------------------------------------------------------------------

tap 'homebrew/bundle'
tap 'homebrew/cask-fonts'
tap 'homebrew/services'
tap 'romkatv/powerlevel10k'
tap 'ngrok/ngrok'
tap 'warrensbox/tap'

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
# Whalebrew allows you to install CLI apps as Docker containers but maintain them in file like Brewfile
# - (https://github.com/whalebrew/whalebrew)
#-------------------------------------------------------------------------------
brew 'whalebrew'

#-------------------------------------------------------------------------------
# Install Binaries
#------------------------------------------------------------------------------

brew 'ripgrep'                                   # fast search
brew 'fd'                                        # Upgrade to 'find'
brew 'sd'                                        # Upgrade to 'sed'
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
brew 'broot'                                        # broot - tree,cd,fuzzy-search
brew 'chrome-cli'
# brew 'bitwarden-cli'                          # password manager CLI -> DO NOT install via Homebrew. Installed via Node (NVM default ver)

brew 'tgswitch'
brew 'cfr-decompiler'
brew 'zola'
brew 'httrack' # website download / mirror tool
brew 'jc' # CLI JSON converter + other useful conversions CLI tool
brew 'rsync' # Util for sync+transfer file+folders (local+remote)
brew 'rclone' # Rsync-like file+folders sync+transfer (local+remote+cloud-providers)
brew 'atuin' # Atuin (https://atuin.sh/) - shell history service (multi-device sync)
brew 'websocat' # Websocket CLI tool
brew 'restic' # Restic (backups) https://restic.net/
brew 'imagemagick' # ImageMagick (convert to/from images) - https://imagemagick.org/index.php

#-------------------------------------------------------------------------------
# Swift + iOS
#-------------------------------------------------------------------------------
brew 'cocoapods'

#-------------------------------------------------------------------------------
# AWS
#-------------------------------------------------------------------------------

brew 'awslogs'
brew 'awscli'
brew 'localstack' # local AWS cloud stack

#-------------------------------------------------------------------------------
# Git + Github
#-------------------------------------------------------------------------------

brew 'git'
brew 'git-flow'
brew 'hub'
brew 'gh' # github cli
brew 'act' # local Github Actions (GHA) runner (using docker)
brew 'git-recent'                                   # viewing latest git branches
brew 'git-delta'                                 # Upgrade to 'diff'
brew 'git-lfs' # Git LFS (large files in Git)

#-------------------------------------------------------------------------------
# Node
#-------------------------------------------------------------------------------
brew 'nvm'                                       # Node version manager

#-------------------------------------------------------------------------------
# terraform + terragrunt
#-------------------------------------------------------------------------------


# Terraform version manager (tfenv) - no need for separate "terraform" brew install with tfenv.
# EXPLICITLY NOT including (brew 'terraform') because it is now managed by "tfenv".
# brew 'terraform'
brew 'tfenv'

# Terraform official language server (ls)
brew 'terraform-ls' # Used for VSCode IDE terraform plugin to do Goto Symbol + etc.

# Terragrunt version manager (tgswitch - https://github.com/warrensbox/tgswitch)
# brew 'terragrunt'
brew 'tgswitch'

#-------------------------------------------------------------------------------
# kubernetes (k8s)
#-------------------------------------------------------------------------------

brew 'kubernetes-cli' # CLI tool for k8s control plane mgmt (kubectl - https://kubernetes.io/docs/reference/kubectl/)
brew 'kubectx' # CLI tool that can switch between kubectl contexts easily and create aliases
brew 'kube-ps1' # kubernetes prompt for zsh + bash
brew 'kops' # Production Grade K8s Installation, Upgrades, and Management
brew 'eksctl' # CLI tool for creating k8s clusters on Amazon EKS

#-------------------------------------------------------------------------------
# Development-Ruby
#-------------------------------------------------------------------------------

brew 'ruby'
brew 'rbenv'

#-------------------------------------------------------------------------------
# Development-Python (includes pip, easy_install)
# + jupyterlab for jupyter notebooks
#-------------------------------------------------------------------------------

brew 'pyenv'
brew 'pyenv-virtualenv'
brew 'jupyterlab' # Jupyter notebook (https://jupyter.org/)

#-------------------------------------------------------------------------------
# OpenAPI/Swagger
# 
#-------------------------------------------------------------------------------
brew 'swagger-codegen'
brew 'openapi-generator'

#-------------------------------------------------------------------------------
# Development-Go
#-------------------------------------------------------------------------------

# brew 'golang' # go language (TODO: preferred : install per-project using direct binary install or goenv similar to pyenv + virtualenvs)
# brew 'golang-migrate' # golang DB migration (TODO: preferred : install per-project using go install)
# brew 'golangci-lint' # golang ci linter (TODO: preferred : install per-project using go install)

#-------------------------------------------------------------------------------
# Development-Java
# NOTE: needed for 'swagger-codegen'
#-------------------------------------------------------------------------------

brew 'java' # java == openjdk
brew 'maven'
brew 'gradle'
brew 'kotlin'

#-------------------------------------------------------------------------------
# Cache (e.g. Redis)
#-------------------------------------------------------------------------------
brew 'redis'

#-------------------------------------------------------------------------------
# Message Queues/Brokers (e.g. Kafka)
#-------------------------------------------------------------------------------
brew 'kafka'

#-------------------------------------------------------------------------------
# Observability/Monitoring
#-------------------------------------------------------------------------------

# TODO: consider using 'whalebrew' to install these as Docker container (OR try using other custom script ways)
# NOTE: HOMEBREW NO LONGER SUPPORTS ELASTICSEARCH - need ZIP file manual install (tap 'elastic/tap') - https://www.elastic.co/guide/en/elasticsearch/reference/8.12/install-elasticsearch.html#elasticsearch-install-packages
# ELK stack Logging (e.g. ElasticSearch, Logstash, Filebeat)
# https://www.elastic.co/guide/en/elasticsearch/reference/7.17/elasticsearch-intro.html
# Elasticsearch : the distributed search and analytics engine at the heart of the Elastic Stack. Elasticsearch is where the indexing, search, and analysis magic happens.
# Logstash and Beats (filebeat?) : facilitate collecting, aggregating, and enriching your data and storing it in Elasticsearch
# Kibana : enables you to interactively explore, visualize, and share insights into your data and manage and monitor the stack. 

# Metrics Visualization (e.g. Grafana, Kibana)
brew 'prometheus' # Service monitoring system and time series database (https://prometheus.io/)
brew 'grafana' # Gorgeous metric visualizations and dashboards for timeseries databases (grafana.com)

#-------------------------------------------------------------------------------
# Databases
#-------------------------------------------------------------------------------

# Postgres
# Feature matrix comparison for major versions (14,15,16) - https://www.postgresql.org/about/featurematrix/
brew 'postgresql@14'
brew 'postgresql@16'

#-------------------------------------------------------------------------------
# Sqlite setup (Homebrew version)
#
# sqlite is keg-only, which means it was not symlinked into /opt/homebrew,
# because macOS already provides this software and installing another version in
# parallel can cause all kinds of trouble.
#
# If you need to have sqlite first in your PATH, run:
#   echo 'export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"' >> ~/.zshrc
# For compilers to find sqlite you may need to set:
#   export LDFLAGS="-L/opt/homebrew/opt/sqlite/lib"
#   export CPPFLAGS="-I/opt/homebrew/opt/sqlite/include"
# For pkg-config to find sqlite you may need to set:
#   export PKG_CONFIG_PATH="/opt/homebrew/opt/sqlite/lib/pkgconfig"
#
#-------------------------------------------------------------------------------
brew 'sqlite'

#-------------------------------------------------------------------------------
# Apps
#-------------------------------------------------------------------------------

cask 'anki' # Anki flashcards (memory retention) - https://apps.ankiweb.net/
cask 'firefox'
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
cask 'signal' # private msg app - signal.org
cask 'notion'
cask 'bartender' # menu bar app manager (v5) - https://www.macbartender.com/
cask 'raycast' # Spotlight replacement - https://raycast.com/
# Bitwarden password manager (exists in Mac App store + Brew Cask) - some issues with App Store version
cask 'bitwarden' # password manager - https://bitwarden.com/
cask 'microsoft-teams'
cask 'arc'
cask 'copilot' # finance app (https://copilot.money/)
cask 'warp' # Rust-based terminal emulator (alternative to iTerm2 - https://www.warp.dev/)
cask 'sunsama' # Sunsama - calendar + task manager (sunsama.com)
cask 'lm-studio' # platform for local LLMs
cask 'obsidian' # notes app Obsidian
cask 'asana' # project management app Asana
cask 'sizzy' # Sizzy dev web browser (https://sizzy.co/)
cask 'maestral' # Maestral alt Dropbox CLI Client
cask 'insync' # Insync (multi cloud storage syncs) - https://www.insynchq.com/
cask 'rippling' # Rippling HR app (for Patter AI)

#-------------------------------------------------------------------------------
# Mac App store downloads into Brewfile (Uses Mac App store CLI - https://github.com/mas-cli/mas).
# The line is like:
# mas "App Name", id: 123456789 (get ID from `$ mas list`)
#-------------------------------------------------------------------------------

# mas "Bitwarden", id: 1352778147 
mas "Bear", id: 1091189122
mas "Commander One", id: 1035236694
mas "Developer", id: 640199958
mas "GarageBand", id: 682658836
mas "Habitify", id: 1111447047
mas "Human Japanese", id: 412213489
mas "KakaoTalk", id: 869223134
mas "Keynote", id: 409183694
mas "Kindle Classic", id: 405399194
mas "LINE", id: 539883307
mas "Magnet", id: 441258766
mas "Numbers", id: 409203825
mas "Omnivore", id: 1564031042
mas "Pages", id: 409201541
mas "Slack", id: 803453959
mas "Tailscale", id: 1475387142
mas "TestFlight", id: 899247664
mas "The Unarchiver", id: 425424353
mas "Toggl Track", id: 1291898086
mas "WhatsApp", id: 1147396723
mas "Xcode", id: 497799835
mas "iMovie", id: 408981434
# TODO: App Store ID doesn't work well with below App Store apps - need to figure out how to install via Brewfile.
# # Authy CAN also be installed via website Mac dmg download, BUT App Store Authy is preferred
# mas "Authy", id: 494168017
# mas "Todoist", id: 585829637
# mas "Speechify", id: 1209815023
# mas "MuseScore", id: 835731296 # Piano sheet music + music notation software
# mas "MusicNotes", id: 924050984 # Sheet music store
