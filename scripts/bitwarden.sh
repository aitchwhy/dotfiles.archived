#!/bin/bash

DOWNLOADS_FOLDER="$HOME/Downloads"
BW_NOT_LOGGED_IN_PHRASE="not logged in"

# Function to login to Bitwarden + sync + unlock
# Will save SESSION_KEY to BW_LOGIN_SESSION_KEY variable (or update)
bw_login() {
    # Unlock Bitwarden and synchronize
    # use "--raw" option for login to get SESSION_KEY value for subsequent operations
    # TODO: improve this to be shareable across shell instances (e.g. save to local file) --- but consider security implications of saving session key to file
    export BW_LOGIN_SESSION_KEY=$(bw login --raw)
    if [ -z "$BW_LOGIN_SESSION_KEY" ]; then
        echo "Login failed."
        exit 1
    fi
}

# Function to execute Bitwarden commands
bw_command() {
    bw $@ --session $BW_LOGIN_SESSION_KEY
}

bw_logout() {
    bw logout
    unset BW_LOGIN_SESSION_KEY
    # TODO: unset BW_LOGIN_SESSION_KEY + delete saved key instances (e.g. saved local file)
}

bw_sync() {
    # bw_login
    bw unlock
    bw sync --session "$BW_LOGIN_SESSION_KEY"
}

# Function to list Bitwarden secure notes
bw_list_notes() {
    bw_sync
    bw list items --session "$BW_LOGIN_SESSION_KEY" | jq -r '.[] | select(.type == 2) | .name'
}

# Function to overwrite local files from Bitwarden secure note
bw_mount_to_local() {
    local bw_note_src=$1
    local local_path_dst=$2

    # bw sync
    bw_sync

    # Fetch and overwrite
    echo "Mounting (overwrite) $bw_note_src -> $local_path_dst"
    BW_ITEM_CONTENT=$(bw get item "$bw_note_src" --session "$BW_LOGIN_SESSION_KEY" | jq -r '.notes')
    if [ -z "$BW_ITEM_CONTENT" ]; then
        echo "Secure note content not found in Bitwarden. Returning."
        return
    fi

    echo "$BW_ITEM_CONTENT" >"$local_path_dst"
    echo "Finished mounting (overwrite) $bw_note_src -> $local_path_dst"
}

# Function to update local pg_service.conf from Bitwarden secure note
bw_mount_to_local_pg_service() {
    bw_mount_to_local "pg_service.conf" "$HOME/.pg_service.conf"
}
