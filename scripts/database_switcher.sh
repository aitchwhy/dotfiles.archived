#!/bin/bash

PG_SERVICE_FILE="$HOME/.pg_service.conf"
DOWNLOADS_FOLDER="$HOME/Downloads"
BW_NOT_LOGGED_IN_PHRASE="not logged in"

source "$DOTFILES/scripts/bitwarden.sh"
LOCAL_DB_PROFILE="ansa-ios-backend_localhost"

# Function to list profiles from pg_service.conf
list_pg_profiles() {
    grep '^\[' "$PG_SERVICE_FILE" | tr -d '[]'
}

# Function to list ONLY localhost profiles from pg_service.conf
list_pg_profiles_localhost() {
    list_pg_profiles | grep 'localhost'
}

dump_file_name() {
    local source=$1
    local timestamp=$(date +"%Y-%m-%dT%H-%M-%S")
    echo "${DOWNLOADS_FOLDER}/${source}_${timestamp}_dump.sql"
}

# Function for pg_dump with timestamp
perform_pg_dump() {
    local source=$1
    local dump_file=${2:-$(dump_file_name "$source")}
    # local dump_file=$(dump_file_name "$source")

    echo "Performing pg_dump for source profile: $source to file: $dump_file"
    pg_dump "service=$source" >"$dump_file"
    echo "Dump completed: $dump_file"
}

# Function for pg_restore
perform_pg_restore() {
    local source=$1
    local target=${2:-$LOCAL_DB_PROFILE}
    local dump_file=${3:-$(dump_file_name "$source")}

    if [ ! -f "$dump_file" ]; then
        echo "Dump file not found: $dump_file"
        return
    fi

    echo "Performing psql restore to target profile: $target"
    # pg_restore -d "service=$target" <"$dump_file"
    psql "service=$target" -f "$dump_file"
    echo "Restore completed to profile: $target"
}

db_clone() {
    ################################
    # Pick source profile from pg_service.conf service profiles (pg_dump)
    ################################

    # Fuzzy search to pick source profile
    SOURCE_PROFILE=$(list_pg_profiles | fzf --prompt="Select a source PostgreSQL profile: ")

    if [ -z "$SOURCE_PROFILE" ]; then
        echo "No source profile selected. Returning."
        return
    fi

    echo "Selected source profile: $SOURCE_PROFILE"

    # Perform pg_dump
    dump_file=$(dump_file_name "$SOURCE_PROFILE")
    perform_pg_dump "$SOURCE_PROFILE" "$dump_file"

    ################################
    # Restore data snapshot to target profile on localhost (pg_restore)
    ################################

    # Use fzf to pick a target profile, or use 'localhost_db' as default
    localhost_db_target_profiles=$(list_pg_profiles_localhost)
    TARGET_PROFILE=$(printf '%s\n' "${localhost_db_target_profiles[@]}" | fzf --prompt="Select a target PostgreSQL profile (default: $LOCAL_DB_PROFILE): ")

    # Use default if no profile is selected
    if [ -z "$TARGET_PROFILE" ]; then
        TARGET_PROFILE="$LOCAL_DB_PROFILE"
    fi

    echo "Selected target profile: $TARGET_PROFILE"

    # Perform pg_restore
    perform_pg_restore "$SOURCE_PROFILE" "$TARGET_PROFILE" "$dump_file"
}
