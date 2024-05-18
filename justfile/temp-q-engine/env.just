#############################################################################
# Environment specific configuration (e.g. env vars) --- (dynamically loads environment variables from a file)
# this justfile module is used to source different sets of env-vars
#############################################################################

# Define a parameter for the environment file with a default value
env-file ?= ".env.dev"

# Derive project name from the folder name
project-name := `basename $(pwd)`

# Load and validate environment variables from the specified file
@export
load-env:
    if [[ -f {{env-file}} ]]; then
        export $(grep -v '^#' {{env-file}} | xargs)
        # Validate that all environment variables have the correct prefix
        env_vars=$(grep -v '^#' {{env-file}} | cut -d= -f1)
        for var in $env_vars; do
            if [[ ! $var == "${project_name}_*" ]]; then
                echo "Environment variable $var does not have the required prefix ${project_name}_"
                exit 1
            fi
        done
    else
        echo "Environment file {{env-file}} not found"
        exit 1
    fi

    # Print environment variables to see which ones are set
    printenv | grep "^${project_name}_"


# ###########
# set dotenv_load := true


# # Define a variable for the environment file, which can be overridden
# env_file := ".env.dev"

# # Load environment variables from the specified file
# load-env := if [[ -f {{env_file}} ]]; then source {{env_file}}; else echo "Environment file {{env_file}} not found"; exit 1; fi

# # Recipe that takes an optional environment file parameter
# set-env-file env-file:
#     env_file := {{env-file}}

# # Recipe to run commands after loading the environment variables
# run-commands:
#     echo "Running with environment file {{env_file}}"
#     echo "DB_HOST: ${DB_HOST}"
#     echo "DB_PORT: ${DB_PORT}"
#     # Add your actual commands here

# # Main recipe that depends on setting the environment file and loading it
# run-env env-file=".env.dev":
#     set-env-file {{env-file}}
#     load-env
#     run-commands

# # Default recipe
# default:
#     run-env ".env.dev"
