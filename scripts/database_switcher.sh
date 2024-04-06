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
    local SOURCE_PROFILE=$1
    local DUMP_FILE=$2
    if [ -z "$DUMP_FILE" ]; then
        echo "(perform_pg_dump) No DB dump file name provided. Exiting." >&2 
        return 1
    fi
    echo "Performing pg_dump for source profile: $SOURCE_PROFILE to file: ($DUMP_FILE)" >&2
    pg_dump "service=$SOURCE_PROFILE" >"$DUMP_FILE"
    echo "Dump completed: ($DUMP_FILE)" >&2
}

# Function for pg_restore
perform_pg_restore() {
    local TARGET_PROFILE=${1:-$LOCAL_DB_PROFILE}
    local DUMP_FILE=$2
    if [ ! -f "$DUMP_FILE" ]; then
        echo "(perform_pg_restore) Dump file not found: ($DUMP_FILE)" >&2
        return 1
    fi

    echo "Performing psql restore to target profile: ($TARGET_PROFILE)" >&2
    # psql version 14.11 or above. Use --file with FULL path (if with --file) or relative path OK if (without --file)
    psql "service=$TARGET_PROFILE" --file "$DUMP_FILE" >&2
    echo "Restore completed to profile: ($TARGET_PROFILE)" >&2
}

db_source_pick() {
    # Fuzzy search to pick source profile
    SOURCE_PROFILE=$(list_pg_profiles | fzf --prompt="Select a source PostgreSQL profile: ")
    if [ -z "$SOURCE_PROFILE" ]; then
        # redirect echo output to stderr(2) instead of default (stdout 1) to avoid including debug log string into returned shell function
        # "&2" uses "&" to denote "2" as file descriptor and NOT file name
        echo "No source profile selected. Returning." >&2 
        return 1
    fi

    echo "Selected source profile: ($SOURCE_PROFILE)" >&2
    echo "$SOURCE_PROFILE"
}

db_dump() {
    ################################
    # Pick source profile from pg_service.conf service profiles (pg_dump)
    ################################
    SOURCE_PROFILE="$1"
    if [ -z "$SOURCE_PROFILE" ]; then
        echo "No source profile provided. Picking one from the list." >&2 
        SOURCE_PROFILE=$(db_source_pick)
    fi
    if [ -z "$SOURCE_PROFILE" ]; then
        echo "No source profile selected from list. Exiting." >&2
        return 1
    fi

    # TODO: (hank) ONLY 1 DB type (postgres) is supported now but extend later to include more types.
    DUMP_FILE=$(dump_file_name "$SOURCE_PROFILE")
    perform_pg_dump "$SOURCE_PROFILE" "$DUMP_FILE"
    echo $DUMP_FILE
}

db_restore() {
    ################################
    # Restore data snapshot to target profile on localhost (pg_restore)
    ################################
    local DUMP_FILE=$1
    if [ ! -f "$DUMP_FILE" ]; then
        echo "(db_restore) Dump file not found: ($DUMP_FILE)" >&2
        return 1
    fi

    # Use fzf to pick a target profile, or use 'localhost_db' as default
    localhost_db_target_profiles=$(list_pg_profiles_localhost)
    TARGET_PROFILE=$(printf '%s\n' "${localhost_db_target_profiles[@]}" | fzf --prompt="Select a target PostgreSQL profile (default: $LOCAL_DB_PROFILE): ")
    # Use default if no profile is selected
    if [ -z "$TARGET_PROFILE" ]; then
        TARGET_PROFILE="$LOCAL_DB_PROFILE"
        echo "No target profile selected from list. Using default profile ($LOCAL_DB_PROFILE)."
    fi
    echo "Selected target profile: ($TARGET_PROFILE)"

    # Perform pg_restore
    # TODO: (hank) ONLY 1 DB type (postgres) is supported now but extend later to include more types.
    perform_pg_restore "$TARGET_PROFILE" "$DUMP_FILE"
}

db_clone() {
    SOURCE_PROFILE=$(db_source_pick)
    DUMP_FILE=$(db_dump $SOURCE_PROFILE)
    db_restore $DUMP_FILE


    # ################################
    # # Pick source profile from pg_service.conf service profiles (pg_dump)
    # ################################

    # # Fuzzy search to pick source profile
    # SOURCE_PROFILE=$(list_pg_profiles | fzf --prompt="Select a source PostgreSQL profile: ")

    # if [ -z "$SOURCE_PROFILE" ]; then
    #     echo "No source profile selected. Returning."
    #     return
    # fi

    # echo "Selected source profile: $SOURCE_PROFILE"

    # # Perform pg_dump
    # dump_file=$(dump_file_name "$SOURCE_PROFILE")
    # perform_pg_dump "$SOURCE_PROFILE" "$dump_file"

    # ################################
    # # Restore data snapshot to target profile on localhost (pg_restore)
    # ################################

    # # Use fzf to pick a target profile, or use 'localhost_db' as default
    # localhost_db_target_profiles=$(list_pg_profiles_localhost)
    # TARGET_PROFILE=$(printf '%s\n' "${localhost_db_target_profiles[@]}" | fzf --prompt="Select a target PostgreSQL profile (default: $LOCAL_DB_PROFILE): ")

    # # Use default if no profile is selected
    # if [ -z "$TARGET_PROFILE" ]; then
    #     TARGET_PROFILE="$LOCAL_DB_PROFILE"
    # fi

    # echo "Selected target profile: $TARGET_PROFILE"

    # # Perform pg_restore
    # perform_pg_restore "$SOURCE_PROFILE" "$TARGET_PROFILE" "$dump_file"
}
