# Define a parameter for the environment file with a default value
# env-file ?= ".env.dev"

# # Derive project name from the folder name
# project-name := "{{project_name}}"
# set project_name := `basename $(pwd)`

# # Load and validate environment variables from the specified file
# @export
# load-env:
#     if [[ -f {{env-file}} ]]; then
#         source {{env-file}}
#         # Export environment variables
#         export $(grep -v '^#' {{env-file}} | xargs)

#         # Validate that all environment variables have the correct prefix
#         env_vars=$(grep -v '^#' {{env-file}} | cut -d= -f1)
#         for var in $env_vars; do
#             if [[ ! $var == "${project_name}_*" ]]; then
#                 echo "Environment variable $var does not have the required prefix ${project_name}_"
#                 exit 1
#             fi
#         done
#     else
#         echo "Environment file {{env-file}} not found"
#         exit 1
#     fi

#     # Print environment variables to see which ones are set
#     printenv | grep "^${project_name}_"

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
