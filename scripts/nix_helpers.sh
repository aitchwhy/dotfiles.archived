#!/usr/bin/env bash

#####################
# Nix helpers 
#####################

# Install Nix latest version
nix_install_latest_ver() {
    # Install Nix (latest version) - https://nixos.org/manual/nix/stable/installation/
    echo "Installing Nix latest version"
    bash <(curl -L https://nixos.org/nix/install) --daemon
}

# Install Nix pinned version (2.21.0 latest as of Apr 12, 2024)
nix_install_pinned_ver() {
    # see all release versions on (https://nixos.org/download.html)
    local VERSION=2.21.0
    echo "Installing Nix version $VERSION"
    curl -L "https://releases.nixos.org/nix/nix-$VERSION/install" | sh
}

nix_upgrade() {
    # TODO: https://nixos.org/manual/nix/stable/installation/upgrading
    echo "TODO"
}

nix_package_install_chezmoi_dotfiles() {
    echo "Installing Chezmoi with Nix package manager..."
    nix profile install nixpkgs#chezmoi

    # echo "Initializing Chezmoi with local dotfiles directory..."
    # chezmoi init --apply --source $DOTFILES/chezmoi
}

nix_clean() {
    # https://nixos.org/manual/nix/stable/quick-start
    nix-collect-garbage --delete-old
}

# Install Home Manager (to be used for new machine setup in bootstrap.sh)
# https://nix-community.github.io/home-manager/index.xhtml#sec-install-standalone
nix_home_manager_install() {
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    nix-shell '<home-manager>' -A install
}

# Add shell integration to auto create Nix+Direnv to new Github repositories
# (https://github.com/nix-community/nix-direnv/wiki/Shell-integration)
nixify() {
    if [ ! -e ./.envrc ]; then
        echo "use nix" >.envrc
        direnv allow
    fi
    if [[ ! -e shell.nix ]] && [[ ! -e default.nix ]]; then
        cat >default.nix <<'EOF'
with import <nixpkgs> {};
mkShell {
    nativeBuildInputs = [
        bashInteractive
    ];
}
EOF
        ${EDITOR:-vim} default.nix
    fi
}

flakify() {
    if [ ! -e flake.nix ]; then
        nix flake new -t github:nix-community/nix-direnv .
    elif [ ! -e .envrc ]; then
        echo "use flake" >.envrc
        direnv allow
    fi
    ${EDITOR:-vim} flake.nix
}

nix_init() {
    nix_install_latest_ver

    echo "Reloading Zsh configuration..."
    source ~/.zshrc

    # Install Chezmoi dotfiles manager via Nix pkg manager (nix profile)
    nix_package_install_chezmoi_dotfiles

    # TODO: Nix home-manager
    # nix_home_manager_install

    # TODO: Nix-darwin
}
