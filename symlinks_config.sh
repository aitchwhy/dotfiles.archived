# Define symlink mappings
# {src ORIG path}:{ALIAS symlink}
SUDO_SYMLINKS=(
    # Java (OpenJDK) setup (NEEDS 'sudo')
    "$BREW_PREFIX/opt/openjdk/libexec/openjdk.jdk:/Library/Java/JavaVirtualMachines/openjdk.jdk"
)
SYMLINKS=(
    # Brew Bundle file
    "$DOTFILES/Brewfile:$HOME/Brewfile"

    # Zsh configs linked
    "$DOTFILES/.zshrc:$HOME/.zshrc"

    # Vim configs linked
    "$DOTFILES/.vimrc:$HOME/.vimrc"

    # tmux config files linked
    "$DOTFILES/.tmux.conf:$HOME/.tmux.conf"

    # Direnv global RC file link (env vars per project)
    "$DOTFILES/.direnvrc:$HOME/.config/direnv/direnvrc"

    # dir colors (zsh color config)
    "$DOTFILES/.dir_colors:$HOME/.dir_colors"

    # Doom directory
    "$DOTFILES/.doom.d:$HOME/.doom.d"

    # Powerlevel10k
    "$DOTFILES/.p10k.zsh:$HOME/.p10k.zsh"

    # Default global NPM packages installed for every NVM new version installation
    # nvm reinstall-packages <node-version> <---- Reinstall global `npm` packages contained in <version> to current version
    # NOTE: <version> CANNOT be same as current NVM selected version when running this command
    # NOTE: default-packages MUST have 1 line at the end of file (otherwise it will not work)
    "$DOTFILES/default-packages:$NVM_DIR/default-packages"
)

# import "link" function
source $DOTFILES/.functions

create_symlinks() {
    for pair in "${SYMLINKS[@]}"; do
        local src="${pair%%:*}"
        local dest="${pair##*:}"
        link "$src" "$dest"
    done
}
create_sudo_symlinks() {
    for pair in "${SUDO_SYMLINKS[@]}"; do
        local src="${pair%%:*}"
        local dest="${pair##*:}"
        sudo_link "$src" "$dest"
    done
}

# Create symlinks by default (but not sudo ones)
create_symlinks
