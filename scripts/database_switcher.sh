#!/bin/bash

PG_SERVICE_FILE="$HOME/.pg_service.conf"
DOWNLOADS_FOLDER="$HOME/Downloads"
LOCAL_DB_PROFILE="localhost-db"

# Function to list Bitwarden items
list_bw_items() {
    bw list items | jq -r '.[] | select(.attachments) | .name'
}

# Function to list Bitwarden secure notes
list_bw_notes() {
    bw list items | jq -r '.[] | select(.type == 2) | .name'
}

update_pg_service_from_bitwarden() {
    local DEFAULT_BW_ITEM_NAME="pg_service.conf"

    # Unlock Bitwarden and synchronize
    bw login
    bw unlock
    bw sync

    # Use provided argument or select using fzf
    BW_ITEM_NAME=$(list_bw_notes | fzf --prompt="Select a Bitwarden secure note: ") || echo "$DEFAULT_BW_ITEM_NAME"

    # Use default if no item is selected or provided
    if [ -z "$BW_ITEM_NAME" ]; then
        BW_ITEM_NAME="$DEFAULT_BW_ITEM_NAME"
    fi

    # Fetch and overwrite pg_service.conf
    BW_ITEM_CONTENT=$(bw get item "$BW_ITEM_NAME" | jq -r '.notes')
    if [ -z "$BW_ITEM_CONTENT" ]; then
        echo "Secure note content not found in Bitwarden. Returning."
        return
    fi

    echo "$BW_ITEM_CONTENT" >"$PG_SERVICE_FILE"
    echo "pg_service.conf updated from secure note: $BW_ITEM_NAME"
}

# Function to list profiles from pg_service.conf
list_pg_profiles() {
    grep '^\[' "$PG_SERVICE_FILE" | tr -d '[]'
}

# Function for pg_dump with timestamp
perform_pg_dump() {
    local source=$1
    local timestamp=$(date +"%Y-%m-%dT%H:%M:%S")
    local dump_file="${DOWNLOADS_FOLDER}/${source}_${timestamp}_dump.sql"

    echo "Performing pg_dump for source profile: $source to file: $dump_file"
    pg_dump "service=$source" >"$dump_file"
    echo "Dump completed: $dump_file"
}

# Function for pg_restore
perform_pg_restore() {
    local source=$1
    local target=${2:-$LOCAL_DB_PROFILE}
    local dump_file="${DOWNLOADS_FOLDER}/${source}_dump.sql"

    if [ ! -f "$dump_file" ]; then
        echo "Dump file not found: $dump_file"
        return
    fi

    echo "Performing pg_restore to target profile: $target"
    pg_restore -d "service=$target" <"$dump_file"
    echo "Restore completed to profile: $target"
}

db_clone() {
    # Fuzzy search to pick source profile
    SOURCE_PROFILE=$(list_pg_profiles | fzf --prompt="Select a source PostgreSQL profile: ")

    if [ -z "$SOURCE_PROFILE" ]; then
        echo "No source profile selected. Returning."
        return
    fi

    echo "Selected source profile: $SOURCE_PROFILE"

    # Perform pg_dump
    perform_pg_dump "$SOURCE_PROFILE"

    # Ask for target profile or use 'localhost_db'
    echo "Enter target profile for pg_restore (leave blank to use '$LOCAL_DB_PROFILE'):"
    read -rp "Target profile (default: $LOCAL_DB_PROFILE): " TARGET_PROFILE
    perform_pg_restore "$SOURCE_PROFILE" "$TARGET_PROFILE"
}
