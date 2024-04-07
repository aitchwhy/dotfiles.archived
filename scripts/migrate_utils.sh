#!/bin/bash

####################################
# golang-migrate helper commands (https://github.com/golang-migrate/migrate)
# migrate CLI docs : https://github.com/golang-migrate/migrate/tree/master/cmd/migrate
####################################

PROJECT_ROOT="$(git rev-parse --show-toplevel)"

# Default values for Postgres DB conn are "localhost docker-compose postgres DB" values
# But default values can be overridden by caller to populate specific variables (e.g. POSTGRESQL_HOST)
POSTGRESQL_HOST=${POSTGRESQL_HOST:-localhost}
POSTGRESQL_PORT=${POSTGRESQL_PORT:-54320}
POSTGRESQL_DB=${POSTGRESQL_DB:-ansa}
POSTGRESQL_USER=${POSTGRESQL_USER:-ansa}
POSTGRESQL_PASSWORD=${POSTGRESQL_PASSWORD:-bowieandearl}
POSTGRESQL_URL="postgresql://${POSTGRESQL_USER}:${POSTGRESQL_PASSWORD}@${POSTGRESQL_HOST}:${POSTGRESQL_PORT}/${POSTGRESQL_DB}?sslmode=disable"

GOLANG_MIGRATE_SHELL_CLI_BINARY_NAME="migrate"
MIGRATE_LOCK_TIMEOUT=${MIGRATE_LOCK_TIMEOUT:-20}
MIGRATE_PATH=${MIGRATE_PATH:-"${PROJECT_ROOT}/migrations/schema"}
MIGRATE_FUNC_PREFIX="migrate"

VALID_MIGRATE_COMMANDS_NO_ARG=("migrate-help" "migrate-version" "migrate-up" "migrate-down" "migrate-drop" "migrate-unset-dirty" "migrate-reset" "migrate-test-fully-up" "migrate-test-fully-down")
VALID_MIGRATE_COMMANDS_ONE_ARG=("migrate-up-n" "migrate-down-n" "migrate-force" "migrate-goto" "migrate-create")
# Combine no-arg + one-arg valid commands to get full command list
VALID_MIGRATE_COMMANDS=("${VALID_MIGRATE_COMMANDS_NO_ARG[@]}" "${VALID_MIGRATE_COMMANDS_ONE_ARG[@]}")

# LATEST migration = last in lexicographical / numerical ASC order
# Golang-migrate docs on expected filename patterns for migration files
# filename pattern : migrations/schema/{version}_{title}.(up|down).{extension}
# filename real    : migrations/schema/000001_bootstrap_ledger_tables.down.sql
MIGRATION_FILE_REGEX_ALL="^([0]+[0-9]+)_([^.]*)\.(up|down)\.(sql)$"
MIGRATION_FILE_REGEX_UP="^([0]+[1-9]+)_([^.]*)\.up\.(sql)$"
MIGRATION_FILE_REGEX_DOWN="^([0]+[1-9]+)_([^.]*)\.down\.(sql)$"

checkdeps() {
    if ! [ -x "$(command -v ${GOLANG_MIGRATE_SHELL_CLI_BINARY_NAME})" ]; then
        echo "${GOLANG_MIGRATE_SHELL_CLI_BINARY_NAME} is not installed"
        return 1
    fi
}

get-all-migrate-commands-no-arg() {
    # Validate that defined shell functions match with hardcoded array of valid function names
    if ! validate-commands-parity-defined-and-valid-list; then
        echo "Commands mismatch between defined functions (functions defined in this file prefixed with MIGRATE_FUNC_PREFIX) VS valid command list (VALID_MIGRATE_COMMANDS)" >&2
        return 1
    fi
    # Output valid commands each on 1 line
    echo "${VALID_MIGRATE_COMMANDS_NO_ARG[@]}"

    return 0
}

get-all-migrate-commands-one-arg() {
    # Validate that defined shell functions match with hardcoded array of valid function names
    if ! validate-commands-parity-defined-and-valid-list; then
        echo "Commands mismatch between defined functions (functions defined in this file prefixed with MIGRATE_FUNC_PREFIX) VS valid command list (VALID_MIGRATE_COMMANDS)" >&2
        return 1
    fi
    # Output valid commands each on 1 line
    echo "${VALID_MIGRATE_COMMANDS_ONE_ARG[@]}"
}

get-all-migrate-commands() {
    local all_valid_commands=("$(get-all-migrate-commands-no-arg) $(get-all-migrate-commands-one-arg)")
    echo $all_valid_commands
}

validate-commands-parity-defined-and-valid-list() {
    # Validate that defined shell functions match with hardcoded array of valid function names
    local dynamically_parsed_commands=()
    while IFS= read -r cmd; do
        dynamically_parsed_commands+=("$cmd")
    done < <(grep -E "^${MIGRATE_FUNC_PREFIX}-[a-zA-Z0-9_-]+\(\)" "$0" | sed 's/().*$//')

    # Convert both arrays to strings sorted by their elements
    local sorted_hardcoded=$(printf '%s\n' "${VALID_MIGRATE_COMMANDS[@]}" | sort)
    local sorted_dynamic=$(printf '%s\n' "${dynamically_parsed_commands[@]}" | sort)

    # Compare the sorted strings
    if [ "$sorted_hardcoded" == "$sorted_dynamic" ]; then
        return 0
    else
        return 1
    fi
}

validate-migrate-command() {
    local cmd_to_check="$1"
    local valid=1  # Assume command is not valid initially (1 for false in shell script convention)

    # Iterate through all commands output by get-all-migrate-commands
    for cmd in $(get-all-migrate-commands); do
        if [[ "$cmd_to_check" == "$cmd" ]]; then
            valid=0  # Command is valid (0 for true in shell script convention)
            break
        fi
    done

    return $valid
}

validate-migration-step-num() {
    local n="$1"
    if ! [[ "$n" =~ ^[0-9]+$ ]]; then
        echo "Error: argument must be a valid number"
        return 1
    fi
}

validate-migration-new-name() {
    local NEW_MIGRATION_NAME="$1"
    if [[ $NEW_MIGRATION_NAME =~ $MIGRATION_FILE_REGEX_ALL ]]; then
        local version="${BASH_REMATCH[1]}"
        local title="${BASH_REMATCH[2]}"
        local direction="${BASH_REMATCH[3]}"
        local extension="${BASH_REMATCH[4]}"
        
        echo "Valid migration file name."
        echo "Version: $version, Title: $title, Direction: $direction, Extension: $extension"
        return 0
    else
        echo "Invalid migration file name. Please ensure the name matches the expected format:" >&2
        echo "  {version}_{title}.(up|down).{extension}" >&2
        return 1
    fi
}

handle-migrate-version-output() {
    local migrate_ver_output="$1"
    local ret_code="$2"

    if [ "$ret_code" -ne 0 ]; then
        if echo "$migrate_ver_output" | grep -q "no migration"; then
            echo "no migrations have been applied"
            return 1
        else
            echo "Unexpected error occurred"
            return 1
        fi
    else
        local curr_migration_version=$(echo "$migrate_ver_output" | tail -1 | grep -o '[0-9]*')
        echo "$curr_migration_version"
        return 0
    fi
}

migrate-help() {
    echo "Usage: $0 <command>"
    echo "Available commands:"
    for cmd in $(get-all-migrate-commands); do
        echo "  $cmd"
    done
}

migrate-version() {
    migrate -database "${POSTGRESQL_URL}" -path ${MIGRATE_PATH} -lock-timeout=${MIGRATE_LOCK_TIMEOUT} version
}

migrate-create() {
    # Create a set of timestamped UP/DOWN migrations titled "", in directory D with extension E.
    local NEW_MIGRATION_NAME="$1"
    migrate create -ext sql -dir ${MIGRATE_PATH} $NEW_MIGRATION_NAME
}

migrate-up() {
    # Apply ALL UP migrations
    migrate -database "${POSTGRESQL_URL}" -path ${MIGRATE_PATH} -lock-timeout=${MIGRATE_LOCK_TIMEOUT} -verbose up
}

migrate-up-n() {
    # Apply "n" UP migrations
    local n="$1"
    validate-migration-step-num $n
    migrate -database "${POSTGRESQL_URL}" -path ${MIGRATE_PATH} -lock-timeout=${MIGRATE_LOCK_TIMEOUT} -verbose up $n
}

migrate-down() {
    # Apply ALL DOWN migrations
    yes | migrate -database "${POSTGRESQL_URL}" -path ${MIGRATE_PATH} -lock-timeout=${MIGRATE_LOCK_TIMEOUT} -verbose down
}

migrate-down-n() {
    # Apply "n" DOWN migrations
    local n="$1"
    validate-migration-step-num $n
    yes | migrate -database "${POSTGRESQL_URL}" -path ${MIGRATE_PATH} -lock-timeout=${MIGRATE_LOCK_TIMEOUT} -verbose down $n
}

migrate-drop() {
    # Drop everything inside database
    migrate -database "${POSTGRESQL_URL}" -path ${MIGRATE_PATH} -lock-timeout=${MIGRATE_LOCK_TIMEOUT} -verbose drop -f
}

migrate-unset-dirty() {
    # From golang-migrate docs FAQ page : https://github.com/golang-migrate/migrate/blob/master/FAQ.md#what-does-dirty-database-mean
    # > Before a migration runs, each database sets a dirty flag.
    # > Execution stops if a migration fails and the dirty state persists, which prevents attempts to run more migrations on top of a failed migration.
    # > You need to manually fix the error and then "force" the expected version.
    if ! [ -x "$(command -v psql)" ]; then
        echo "psql is not installed - returning"
        return 1
    fi
    PGPASSWORD=${POSTGRESQL_PASSWORD} psql -h ${POSTGRESQL_HOST} -p ${POSTGRESQL_PORT} -U ${POSTGRESQL_USER} -d ${POSTGRESQL_DB} -c "update schema_migrations set dirty='f';" 2>&1
}

migrate-force() {
    # set version "n" but don't run migration (ignores dirty state)
    local n="$1"
    validate-migration-step-num $n
    migrate -database "${POSTGRESQL_URL}" -path ${MIGRATE_PATH} -lock-timeout=${MIGRATE_LOCK_TIMEOUT} -verbose force $n
}

migrate-goto() {
    # migrate to version "n"
    local n="$1"
    validate-migration-step-num $n
    migrate -database "${POSTGRESQL_URL}" -path ${MIGRATE_PATH} -lock-timeout=${MIGRATE_LOCK_TIMEOUT} -verbose goto $n
}

migrate-reset() {
    migrate-drop
    migrate-up
}

migrate-test-fully-up() {
    migrate_ver_output=$(migrate-version 2>&1)
    migrate_ver_output_ret_code=$?

    curr_migration_version=$(handle-migrate-version-output "$migrate_ver_output" "$migrate_ver_output_ret_code")
    handle_migrate_version_output_ret_code=$?
    expected_migration_version=$(ls -1 ${MIGRATE_PATH} | sed -nE "s/${MIGRATION_FILE_REGEX_UP}/\1/p" | sed 's/^0*//' | tail -1)

    if [ "$handle_migrate_version_output_ret_code" -ne 0 ]; then
        echo "[FAIL] testing full UP migration failed ($curr_migration_version)"
        return $handle_migrate_version_output_ret_code
    fi

    if [ "$curr_migration_version" != "$expected_migration_version" ]; then
        echo "[FAIL] testing full UP migration failed (migration version mismatch - expected: $expected_migration_version != got: $curr_migration_version)"
        return 1
    fi
    echo "[PASS] testing full UP migration passed (migration versions match - expected : $expected_migration_version == got: $curr_migration_version)"
    return 0
}

migrate-test-fully-down() {
    migrate_ver_output=$(migrate-version 2>&1)
    migrate_ver_output_ret_code=$?

    curr_migration_version=$(handle-migrate-version-output "$migrate_ver_output" "$migrate_ver_output_ret_code")
    handle_migrate_version_output_ret_code=$?
    expected_migration_version=0

    if echo "$curr_migration_version" | grep -q "no migration"; then
        echo "[PASS] testing full DOWN migration passed (migration versions match - expected : $expected_migration_version == got: 0 ($curr_migration_version))"
        return 0
    fi

    if [ "$handle_migrate_version_output_ret_code" -ne 0 ]; then
        echo "[FAIL] testing full DOWN migration failed ($curr_migration_version)"
        return $handle_migrate_version_output_ret_code
    fi

    if [ "$curr_migration_version" != "$expected_migration_version" ]; then
        echo "[FAIL] testing full DOWN migration failed (migration version mismatch - expected: $expected_migration_version != got: $curr_migration_version)"
        return 1
    fi
    echo "[PASS] testing full DOWN migration passed (migration version match - expected: $expected_migration_version == got: $curr_migration_version)"
    return 0
}

usage() {
    echo "Usage: $0 <command>"
    echo "Available commands:"
    for cmd in $(get-all-migrate-commands-no-arg); do
        echo "  $cmd"
    done
    for cmd in $(get-all-migrate-commands-one-arg); do
        echo "  $cmd <arg>"
    done
}

# Generic function to execute migrate commands with dependency check
run_with_deps() {
    checkdeps
    USER_SUPPLIED_CMD="$1"
    # This drops the first argument ($1), making $2 become $1, $3 become $2, etc.
    shift

    # Dynamically execute the function based on $CMD (after validation)
    if validate-migrate-command "$USER_SUPPLIED_CMD"; then
        # Call the function or command with the rest of the arguments
        "$USER_SUPPLIED_CMD" "$@"
    else
        echo "INVALID COMMAND (NOT found): $USER_SUPPLIED_CMD"
        usage
        return 1
    fi
}

# Main script logic
run_with_deps "$@"
