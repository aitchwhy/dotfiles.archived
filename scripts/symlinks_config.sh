#!/opt/homebrew/bin/zsh

# echo "Symlink all config dotfiles ---> SHELL: $SHELL --- NVM_DIR: $NVM_DIR"

# Define symlink mappings
# {src ORIG path}:{ALIAS symlink}
SUDO_SYMLINKS=(
    # Java (OpenJDK) setup (NEEDS 'sudo')
    "$BREW_PREFIX/opt/openjdk/libexec/openjdk.jdk:/Library/Java/JavaVirtualMachines/openjdk.jdk"
)
SYMLINKS=(
    # Brew Bundle file (default looks for ~/.Brewfile OR can set with HOMEBREW_BUNDLE_FILE_GLOBAL)
    "$DOTFILES/Brewfile:$HOME/.Brewfile"

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

    # pyenv global python version
    "$DOTFILES/pyenv-global-python.version:$PYENV_ROOT/version"

    # TODO: make this link more resilient

    # Default global NPM packages installed for every NVM new version installation
    # nvm reinstall-packages <node-version> <---- Reinstall global `npm` packages contained in <version> to current version
    # NOTE: <version> CANNOT be same as current NVM selected version when running this command
    # NOTE: default-packages MUST have 1 line at the end of file (otherwise it will not work)
    "$DOTFILES/default-packages:$NVM_DIR/default-packages"
)

# import "link" function
source $DOTFILES/scripts/.functions.sh

create_symlinks() {
    for pair in "${SYMLINKS[@]}"; do
        local src="${pair%%:*}"
        local dest="${pair##*:}"
        # echo "[SHELL:$SHELL] Creating symlink $src -> $dest"
        link "$src" "$dest"
    done
}
create_sudo_symlinks() {
    for pair in "${SUDO_SYMLINKS[@]}"; do
        local src="${pair%%:*}"
        local dest="${pair##*:}"
        # echo "[SHELL:$SHELL] Creating symlink $src -> $dest"
        sudo_link "$src" "$dest"
    done
}

vscode_dotfiles_sync() {
    # Sync VSCode settings to Dropbox
    # Assumes VSCode user setting for extension ("bookmarks.saveBookmarksInProject = true)
    # https://marketplace.visualstudio.com/items?itemName=alefragnani.Bookmarks

    # Define the root directory of your local GitHub repositories
    GITHUB_ROOT="$WORKSPACE_ROOT"

    # Define the Dropbox root directory for bookmarks
    DROPBOX_ROOT="$DROPBOX/vscode/bookmarks"

    # Ensure the Dropbox bookmarks directory exists
    mkdir -p "$DROPBOX_ROOT"

    # echo "Symlinking bookmarks with (local workspace folder : $GITHUB_ROOT) -> (dropbox folder : $DROPBOX_ROOT)"

    # Loop through each project in the GitHub root directory
    for project_dir in "$GITHUB_ROOT"/*; do
        if [ -d "$project_dir" ]; then
            # Extract the project folder name
            project_folder_name=$(basename "$project_dir")

            # Path to the bookmarks file in the project
            bookmarks_file="$project_dir/.vscode/bookmarks.json"

            # Symlinking bookmarks file to Dropbox
            # ln -s "$bookmarks_file" "$DROPBOX_ROOT/${project_folder_name}-bookmarks.json"
            local src="${DROPBOX_ROOT}/${project_folder_name}-bookmarks.json"
            local dst="${bookmarks_file}"
            echo "Symlinking bookmarks file: $src <- $dst"
            link "$src" "$dst"

        fi
    done

    echo "Syncing completed."

}

# Create symlinks by default (but not sudo ones)
create_symlinks

# vscode_dotfiles_sync
