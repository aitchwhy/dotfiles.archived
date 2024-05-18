############################################################
# Justfile docs - https://just.systems/man/en/
# Justfile cheatsheet https://cheatography.com/linux-china/cheat-sheets/justfile/
# Justfile Github repo - https://github.com/casey/just
# Justfile tips - https://www.stuartellis.name/articles/just-task-runner/
# TODO: [no-cd] recipe attribute -> if mod imported use parent cwd instead of child path (https://just.systems/man/en/chapter_32.html#disabling-changing-directory190)
############################################################

############################################################
# Justfile settings (https://just.systems/man/en/chapter_26.html)
# - 'shell' : Set the command used to invoke recipes and evaluate backticks.
############################################################
set shell := ["bash", "-cu"]

############################################################
# Justfile imports (other justfiles + modules)
# - modules : https://just.systems/man/en/chapter_54.html
############################################################
# import 'webi/justfile'
# import 'asdf/justfile'
# mod 'modNameFolderName' 'module path'

############################################################
# Justfile Env-vars (https://just.systems/man/en/chapter_31.html#environment-variables)
############################################################
# set dotenv-filename := ".env.local"
# set dotenv-filename := "../../.env"
# set dotenv-filename := "~/.env"
set dotenv-filename := "~/.env"

salesforce-host := env_var('SALESFORCE_PATTER_AI_ORG_HOST')
salesforce-user := env_var('SALESFORCE_PATTER_AI_ORG_USER')
salesforce-password := env_var('SALESFORCE_PATTER_AI_ORG_PASS')
salesforce-token := env_var('SALESFORCE_PATTER_AI_ORG_SECURITY_TOKEN')

# use dotfiles/.export.sh to set these env vars (or use default)
user_justfile_name := env_var('USER_JUSTFILE_NAME', ".user.justfile")
user_justfile_path := "{{ home_directory() }}/" + user_justfile_name
dotfiles_root_dir := justfile_directory()
scripts_root_dir := dotfiles_root_dir / "scripts"
# chezmoi_root_dir := dotfiles_root_dir / "chezmoi"
# webi_root_dir := dotfiles_root_dir / "webi"

# List available recipes
# (TODO: update to add 2nd user justfile command to run aliased HOME dir user justfile)
help:
    @echo "dotfiles root dir: {{dotfiles_root_dir}}"
    @echo "scripts root dir: {{scripts_root_dir}}"
    @just --list -f "{{dotfiles_root_dir}}/{{user_justfile_name}}"

# Display system information
system-info:
    @echo "CPU architecture: {{ arch() }}"
    @echo "Operating system type: {{ os_family() }}"
    @echo "Operating system: {{ os() }}"
    @echo "Home directory: {{ home_directory() }}"


##################################
# global user recipes (cwd = dotfiles root dir)
##################################
[no-cd]
run-recipe-user:
    @just --choose

# formats user.justfile and fixed in place
[no-cd]
format-user-justfile:
    @just --unstable --fmt

# checks user.justfile for syntax errors (return code 0 if no error)
[no-cd]
check-user-justfile:
    @just --unstable --fmt --check

##################################
# Project specific recipes (cwd = project root dir)
##################################

run-recipe-curr:
    @just --choose

# formats user.justfile and fixed in place
format-curr-justfile:
    @just --unstable --fmt

# checks curr project justfile for syntax errors (return code 0 if no error)
check-curr-justfile:
    @just --unstable --fmt --check

init-justfile-current-dir:
    @just --init


help:
    @echo "###################################"
    @echo "salesforce config env-vars"
    @printenv | grep SALESFORCE
    @echo "###################################"
    @echo ""
    @echo ""
    @just --list --unsorted

set shell := ["bash", "-cu"]

# just faster - https://just.systems/man/en/chapter_64.html
alias j=just

# Justfile docs - https://just.systems/man/en/
# Justfile cheatsheet https://cheatography.com/linux-china/cheat-sheets/justfile/

# TODO: update to use tips from below links
# - https://just.systems/man/en/chapter_68.html
# - https://www.stuartellis.name/articles/just-task-runner/
# - https://github.com/casey/just#fallback-to-parent-justfiles

# set dotenv-filename := ".env.local"
# set dotenv-filename := ".env"
# set dotenv-filename := "../../.env"
set dotenv-filename := ".env"

# Define a parameter for the environment file with a default value
env-file ?= ".env.dev"

# Derive project name from the folder name
project-name := "{{project_name}}"
set project_name := `basename $(pwd)`

# Load and validate environment variables from the specified file
@export
load-env:
    if [[ -f {{env-file}} ]]; then
        source {{env-file}}
        # Export environment variables
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



# Justfile Env-vars (https://just.systems/man/en/chapter_31.html#environment-variables)
salesforce-host := env_var('SALESFORCE_PATTER_AI_ORG_HOST')
salesforce-user := env_var('SALESFORCE_PATTER_AI_ORG_USER')
salesforce-password := env_var('SALESFORCE_PATTER_AI_ORG_PASS')
salesforce-token := env_var('SALESFORCE_PATTER_AI_ORG_SECURITY_TOKEN')



# npx jsforce --loginUrl ${SALESFORCE_PATTER_AI_ORG_HOST} \
# --sandbox \
# --username ${SALESFORCE_PATTER_AI_ORG_USER} \
# --password ${SALESFORCE_PATTER_AI_ORG_PASS}${SALESFORCE_PATTER_AI_ORG_SECURITY_TOKEN}


project_root_justfile_dir := justfile_directory()
openapi_root := project_root_justfile_dir / "openapi"
backend_root := project_root_justfile_dir / "backend"

import 'backend/codegen/justfile'
import 'backend/sunlight_financial/justfile'
import 'openapi/justfile'
# import 'apps/q-client/justfile'

help:
    @echo "###################################"
    @echo "salesforce config env-vars"
    @printenv | grep SALESFORCE
    @echo "###################################"
    @echo ""
    @echo ""
    @just --list --unsorted

run-recipe:
    @just --choose

format-justfile-in-place:
    @just --fmt --unstable

# Generate all external API python clients
codegen-clients: codegen-client-sunlight-financial

# Generate q-server FastAPI code
codegen-server: codegen-server-qual-check

# Generate client+server code
codegen-all: codegen-server

# Start FastAPI server and database
start-backend: codegen-all
    docker compose -f {{project_root_justfile_dir}}/docker-compose.yml up

# Start FastAPI server and database in detached mode
start-backend-detached: codegen-all 
    docker compose -f {{project_root_justfile_dir}}/docker-compose.yml up -d

# Stop FastAPI server and database (only if started with detached mode -d)
stop-backend:
    docker compose -f {{project_root_justfile_dir}}/docker-compose.yml down

# Run all unit tests
unit-tests: start-backend-detached
    @echo "TODO: Running Unit tests"

# Run all unit tests
api-tests: start-backend-detached
    @echo "TODO: Running API tests"


# TODO: (May 18)
# # First time Salesforce login (need security token appended to password)
# # Salesforce Security doc : https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_concepts_security.htm

# # sf configs
# # [main]
# #  - org-instance-url               URL of the Salesforce instance hosting your org. Default: https://login.salesforce.com.
# #  - target-org                     Username or alias of the org that all commands run against by default. (sf only)
# # [etc]
# #  - org-api-version                API version of your project. Default: API version of your Dev Hub org.
# #  - target-dev-hub                 Username or alias of your default Dev Hub org. (sf only)
# #  - org-isv-debugger-sid           ISV debugger SID.
# #  - org-isv-debugger-url           ISV debugger URL.
# #  - org-custom-metadata-templates  A valid repository URL or directory for the custom org metadata templates.
# #  - org-max-query-limit            Maximum number of Salesforce records returned by a CLI command. Default: 10,000.
# #  - org-capitalize-record-types    Whether record types are capitalized on scratch org creation.

# sf-cli-org-login:
#     sf org login web
    
# sf-cli-org-list:
#     sf org list --verbose

# sf-cli-config-list:
#     sf config list --verbose

# sf-cli-config-set-local configName configValue:
#     sf config set {{configName}} {{configValue}}

# sf-cli-config-set-global configName configValue:
#     sf config set --global {{configName}} {{configValue}}

# # sf-cli-config-set-global-org-instance-url:
# #     just sf-cli-config-set-global org-instance-url {{SALESFORCE_PATTER_AI_ORG_HOST}}

# # sf-cli-config-set-global-org-target-org:
# #     sf config set target-org {{SALESFORCE_PATTER_AI_ORG_USER}}



# jsforce-cli:
#     npx jsforce --loginUrl ${SALESFORCE_PATTER_AI_ORG_HOST} \
#     --sandbox \
#     --username ${SALESFORCE_PATTER_AI_ORG_USER} \
#     --password ${SALESFORCE_PATTER_AI_ORG_PASS}${SALESFORCE_PATTER_AI_ORG_SECURITY_TOKEN}

# # Query sObjects using SOQL (Salesforce Object Query Language) (https://jsforce.github.io/document/#query)
# # SOQL search syntax docs (https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm)
# jsforce-find-sobject namePattern:
#     npx jsforce --loginUrl ${SALESFORCE_PATTER_AI_ORG_HOST} \
#     --sandbox \
#     --username ${SALESFORCE_PATTER_AI_ORG_USER} \
#     --password ${SALESFORCE_PATTER_AI_ORG_PASS}${SALESFORCE_PATTER_AI_ORG_SECURITY_TOKEN} \
#     --evalScript "query(\"SELECT QualifiedApiName, Label FROM EntityDefinition WHERE QualifiedApiName LIKE '%{{namePattern}}%'\")" | jq

# # Query sObjects using SOQL (Salesforce Object Query Language) (https://jsforce.github.io/document/#query)
# # SOQL search syntax docs (https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm)
# jsforce-describe-sobject name:
#     npx jsforce --loginUrl ${SALESFORCE_PATTER_AI_ORG_HOST} \
#     --sandbox \
#     --username ${SALESFORCE_PATTER_AI_ORG_USER} \
#     --password ${SALESFORCE_PATTER_AI_ORG_PASS}${SALESFORCE_PATTER_AI_ORG_SECURITY_TOKEN} \
#     --evalScript "sobject(\"{{name}}\").describe()" | jq

# jsforce-sobject-schema name:
#     just frontend-jsforce-describe-sobject {{name}} | jq '{ObjectName: .name, Fields: [.fields[] | {FieldName: .name, FieldType: .type}]}'




############################################
# # TODO: Download website from provided URL (1st arg)
# # echo http://example.com/index.php | awk -F[/:] '{print $4}'
# # wget --mirror --convert-links --adjust-extension --page-requisites --no-parent --domains=https://apidocs.slfportal.com/ --execute robots=off https://apidocs.slfportal.com/docs/solar-api-documentation/4b402d5ab3edd-welcome
# download-website url:
#     @echo "Downloading website from provided arg: {{url}}"
#     baseDomain=$(echo {{url}} | awk -F[/:] '{print $4}')
#     @echo "Downloading website from provided arg: {{url}} with base domain: $baseDomain"

# # wget --mirror --convert-links --adjust-extension --page-requisites --no-parent \
# #      --domains=apidocs.slfportal.com \
# #      --include-directories=/docs/solar-api-documentation \
# #      --http-user='solarapidocs@sunlightfinancial.com' --http-password='Mk]PF6_qprKCMU"j' \
# #      https://apidocs.slfportal.com/docs/solar-api-documentation/
# wget --mirror --convert-links --adjust-extension --page-requisites --no-parent \
#      --domains=apidocs.slfportal.com \
#      --include-directories=/docs/solar-api-documentation \
#      --save-cookies cookies.txt \
#      --keep-session-cookies \
#      --post-data 'username=solarapidocs@sunlightfinancial.com&password=Mk%5D%5CPF6%5C_qprKCMU%22j' \
#      --delete-after \
#      --header="Accept: application/json, text/plain, */*" \  
#      --header="Content-Type: application/x-www-form-urlencoded" \
#      "https://apidocs.slfportal.com/api/api-token-auth/" \
#      "https://apidocs.slfportal.com/docs/solar-api-documentation/"


# # https://apidocs.slfportal.com/

# wget --mirror --convert-links --adjust-extension --page-requisites --no-parent \
#      --domains=apidocs.slfportal.com \
#      --include-directories=/docs/solar-api-documentation \
#      --save-cookies cookies.txt \
#      --keep-session-cookies \
#      --post-data 'username=solarapidocs@sunlightfinancial.com&password=Mk%5D%5CPF6%5C_qprKCMU%22j' \
#      --delete-after \
#      --header="Accept: application/json, text/plain, */*" \  
#      "https://apidocs.slfportal.com/api/api-token-auth/" \
#      "https://apidocs.slfportal.com/docs/solar-api-documentation/"


# # ##### request to SLF login
# # curl 'https://apidocs.slfportal.com/api/v1/auth/login' \
# #   -H 'accept: application/json, text/plain, */*' \
# #   -H 'accept-language: en-US,en;q=0.9' \
# #   -H 'cache-control: no-cache' \
# #   -H 'content-type: application/json' \
# #   -H 'cookie: _optimizely_user=qYViD3xIl7p-9CVmansWi; __cf_bm=YomFaE6DJxtOog3AuquFtII5vtFbfCtoJBBMv6R19_I-1715532610-1.0.1.1-dCNCqAyRvDr_x4e4V5hVMWqwfjFrtS52hConQB7h.AEoSf0LBDnRMfvHy_r_NrU9scCzbv0BBfdKoa1eHRfPlg; _gcl_au=1.1.1055324399.1715532610; _gid=GA1.2.533712076.1715532611; _gat_UA-73790375-11=1; _gat_UA-73790375-14=1; _uetsid=9340cf00107e11efb9f1d3dd538eef39; _uetvid=9340e5a0107e11efa85b63e92668b274; _ga=GA1.2.703440579.1715532611; amp_e9074a=iTcASlAF1yHh7BLWXG01WD...1htmrcf12.1htmrcpm6.1.3.4; _ga_FK716NGXTQ=GS1.1.1715532610.1.1.1715532624.46.0.0' \
# #   -H 'origin: https://apidocs.slfportal.com' \
# #   -H 'pragma: no-cache' \
# #   -H 'priority: u=1, i' \
# #   -H 'referer: https://apidocs.slfportal.com/auth/email/login' \
# #   -H 'sec-ch-ua: "Chromium";v="124", "Google Chrome";v="124", "Not-A.Brand";v="99"' \
# #   -H 'sec-ch-ua-mobile: ?0' \
# #   -H 'sec-ch-ua-platform: "macOS"' \
# #   -H 'sec-fetch-dest: empty' \
# #   -H 'sec-fetch-mode: cors' \
# #   -H 'sec-fetch-site: same-origin' \
# #   -H 'stoplight-consumer: ninja' \
# #   -H 'stoplight-consumer-version: 2023.08.0-stable.10997.git-985872d' \
# #   -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36' \
# #   --data-raw '{"workspaceIntegrationId":210232,"usernameOrEmail":"solarapidocs@sunlightfinancial.com","password":"Mk]PF6_qprKCMU\"j","source":"web"}'

# # ##### response to SLF login
# # {
# #     "workspaceId": 56537,
# #     "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL3N0b3BsaWdodC5pby9qd3QvY2xhaW1zIjp7IngtaGFzdXJhLWRlZmF1bHQtcm9sZSI6IndvcmtzcGFjZV91c2VyIiwieC1oYXN1cmEtYWxsb3dlZC1yb2xlcyI6WyJ3b3Jrc3BhY2VfdXNlciJdLCJ4LWhhc3VyYS11c2VyLWlkIjoiMTA0MzgyIiwieC1oYXN1cmEtdXNlci1pcC1hZGRyZXNzIjoiMTAuMTYuOS4xNzEiLCJ4LWhhc3VyYS13b3Jrc3BhY2UtaWQiOiI1NjUzNyJ9LCJpYXQiOjE3MTU1MzI2MjYsImV4cCI6MTcxNTUzMzIyNiwiaXNzIjoic3RvcGxpZ2h0Iiwic3ViIjoiL3VzZXJzLzEwNDM4MiJ9.tBtcrgp3z6oWcPPJSDdkJ7RBiJb7AVR07pXV37VcSMc",
# #     "userId": 104382
# # }


# ##### request to SLF CreateProject API docs page (after successful login)
# curl 'https://stoplight.io/api/v1/projects/cHJqOjgyMzc4/nodes/ZG9jOjE5NzA4NjY4-create-project-overview' \
#   -H 'accept: */*' \
#   -H 'accept-language: en-US,en;q=0.9' \
#   -H 'authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL3N0b3BsaWdodC5pby9qd3QvY2xhaW1zIjp7IngtaGFzdXJhLWRlZmF1bHQtcm9sZSI6IndvcmtzcGFjZV91c2VyIiwieC1oYXN1cmEtYWxsb3dlZC1yb2xlcyI6WyJ3b3Jrc3BhY2VfdXNlciJdLCJ4LWhhc3VyYS11c2VyLWlkIjoiMTA0MzgyIiwieC1oYXN1cmEtdXNlci1pcC1hZGRyZXNzIjoiMTAuMTYuNC4yMCIsIngtaGFzdXJhLXdvcmtzcGFjZS1pZCI6IjU2NTM3In0sImlhdCI6MTcxNTUzMjg4OSwiZXhwIjoxNzE1NTMzNDg5LCJpc3MiOiJzdG9wbGlnaHQiLCJzdWIiOiIvdXNlcnMvMTA0MzgyIn0.y8hqYhLg3bWZMRhndaHBQpSxGy6aG65NZkvTi2GZ6Io' \
#   -H 'cache-control: no-cache' \
#   -H 'origin: https://apidocs.slfportal.com' \
#   -H 'pragma: no-cache' \
#   -H 'priority: u=1, i' \
#   -H 'referer: https://apidocs.slfportal.com/' \
#   -H 'sec-ch-ua: "Chromium";v="124", "Google Chrome";v="124", "Not-A.Brand";v="99"' \
#   -H 'sec-ch-ua-mobile: ?0' \
#   -H 'sec-ch-ua-platform: "macOS"' \
#   -H 'sec-fetch-dest: empty' \
#   -H 'sec-fetch-mode: cors' \
#   -H 'sec-fetch-site: cross-site' \
#   -H 'stoplight-elements-version: 2.1.3' \
#   -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36'

# ##### response from SLF CreateProject API docs page (after successful login)
# {
#   "id": "ZG9jOjE5NzA4NjY4",
#   "branch_node_id": 19565854,
#   "type": "article",
#   "uri": "/docs/create-applicant-main/create-applicant.md",
#   "slug": "ZG9jOjE5NzA4NjY4-create-project-overview",
#   "title": "Create Project - Overview",
#   "summary": "The Create Project API is designed so you can create a Project with an Applicant, without any additional functionality such as creating Quotes, System Designs or running Credit.",
#   "project_id": "cHJqOjgyMzc4",
#   "branch_id": "YnI6MTI5NTQyMw",
#   "branch": "v1.0",
#   "links": {},
#   "outbound_edges": [],
#   "inbound_edges": [],
#   "data": "## Create Project - Overview\n\nThe Create Project API is designed so you can create a Project with an Applicant, without any additional functionality such as creating Quotes, System Designs or running Credit.\n\nCreated Projects can be referred to later to add Quotes, run Credit against and other functionality.\n\nAs with all our APIs, when no id, hashID or externalId is provided, we will create a record. When an id is provided with data, we will update the record, where permitted.\n\n```json title=\"Create Project Request Definition\" jsonSchema\n{\n  \"type\": \"object\",\n  \"properties\": {\n    \"projects\": {\n      \"type\": \"array\",\n      \"items\": {\n        \"type\": \"object\",\n        \"properties\": {\n          \"apr\": {\n            \"type\": \"number\",\n            \"minimum\": 0,\n            \"maximum\": 99.99,\n            \"multipleOf\": 0.01\n          },\n          \"term\": {\n            \"type\": \"integer\"\n          },\n          \"isACH\": {\n            \"type\": \"boolean\"\n          },\n          \"productType\": {\n            \"type\": \"string\"\n          },\n          \"installStreet\": {\n            \"type\": \"string\"\n          },\n          \"installCity\": {\n            \"type\": \"string\"\n          },\n          \"installStateName\": {\n            \"type\": \"string\"\n          },\n          \"installZipCode\": {\n            \"type\": \"string\"\n          },\n          \"applicants\": {\n            \"type\": \"array\",\n            \"items\": {\n              \"type\": \"object\",\n              \"properties\": {\n                \"isPrimary\": {\n                  \"type\": \"boolean\"\n                },\n                \"firstName\": {\n                  \"type\": \"string\"\n                },\n                \"middleInitial\": {\n                  \"type\": \"string\"\n                },\n                \"lastName\": {\n                  \"type\": \"string\"\n                },\n                \"phone\": {\n                  \"type\": \"string\"\n                },\n                \"otherPhone\": {\n                  \"type\": \"string\"\n                },\n                \"email\": {\n                  \"type\": \"string\"\n                },\n                \"mailingStreet\": {\n                  \"type\": \"string\"\n                },\n                \"mailingCity\": {\n                  \"type\": \"string\"\n                },\n                \"mailingStateName\": {\n                  \"type\": \"string\"\n                },\n                \"mailingZipCode\": {\n                  \"type\": \"string\"\n                },\n                \"residenceStreet\": {\n                  \"type\": \"string\"\n                },\n                \"residenceCity\": {\n                  \"type\": \"string\"\n                },\n                \"residenceStateName\": {\n                  \"type\": \"string\"\n                },\n                \"residenceZipCode\": {\n                  \"type\": \"string\"\n                },\n                \"dateOfBirth\": {\n                  \"type\": \"string\"\n                },\n                \"ssn\": {\n                  \"type\": \"string\"\n                },\n                \"annualIncome\": {\n                  \"type\": \"integer\"\n                },\n                \"employerName\": {\n                  \"type\": \"string\"\n                },\n                \"jobTitle\": {\n                  \"type\": \"string\"\n                },\n                \"employmentYears\": {\n                  \"type\": \"string\"\n                },\n                \"employmentMonths\": {\n                  \"type\": \"string\"\n                }\n              },\n              \"required\": [\n                \"isPrimary\",\n                \"firstName\",\n                \"lastName\",\n                \"phone\",\n                \"email\"\n              ]\n            }\n          }\n        },\n        \"required\": [\n          \"installStreet\",\n          \"installCity\",\n          \"installStateName\",\n          \"installZipCode\"\n        ]\n      }\n    }\n  }\n}\n```\n\n### Example - Create Project\n\nIn the below example a Project is created with an Applicant.\n\nPlease note that if you omit mailing and residence address fields for the Applicant, we will populate them for you based on the install address.\n\n<!-- theme: info -->\n\n> #### Before you make a call...\n>\n> Please update the header \"SFAccessToken\" with a token obtained from Authentication!\n\n```json title=\"Create Project Example\" http\n{\n  \"url\": \"https://test.connect.boomi.com/ws/rest/v1/pt/applicant/create\",\n  \"method\": \"post\",\n  \"headers\": {\n    \"Authorization\": \"Basic c3RvcGxpZ2h0YXBpZG9jc0BzdW5saWdodGZpbmFuY2lhbC1XU0hBM1ouTjI5U0NFOjg5NjEwYjA4LTQ2MGQtNGQwNC1iYzg3LWU3ODM2Mjg3MTVhNA==\",\n    \"SFAccessToken\": \"Bearer\",\n    \"Content-Type\": \"application/json\"\n  },\n  \"auth\": {\n    \"type\": \"basic\",\n    \"username\": \"stoplightapidocs@sunlightfinancial-WSHA3Z.N29SCE\",\n    \"password\": \"89610b08-460d-4d04-bc87-e783628715a4\"\n  },\n  \"body\": \"{\\n  \\\"projects\\\": [\\n    {\\n      \\\"apr\\\": 3.99,\\n      \\\"term\\\": 120,\\n      \\\"isACH\\\": true,\\n      \\\"productType\\\": \\\"Solar\\\",\\n      \\\"installStreet\\\": \\\"532 Westwood Road\\\",\\n      \\\"installCity\\\": \\\"Park City\\\",\\n      \\\"installStateName\\\": \\\"Utah\\\",\\n      \\\"installZipCode\\\": \\\"84098\\\",\\n      \\\"applicants\\\": [\\n        {\\n          \\\"isPrimary\\\": true,\\n          \\\"firstName\\\": \\\"Henry\\\",\\n          \\\"middleInitial\\\": \\\"E\\\",\\n          \\\"lastName\\\": \\\"Parker\\\",\\n          \\\"phone\\\": \\\"8054444666\\\",\\n          \\\"otherPhone\\\": \\\"8013131313\\\",\\n          \\\"email\\\": \\\"justanemailaddress@yopmail.com\\\",\\n          \\\"mailingStreet\\\": \\\"4384 Murnin Way\\\",\\n          \\\"mailingCity\\\": \\\"Park City\\\",\\n          \\\"mailingStateName\\\": \\\"Utah\\\",\\n          \\\"mailingZipCode\\\": \\\"84098\\\",\\n          \\\"residenceStreet\\\": \\\"532 Westwood Road\\\",\\n          \\\"residenceCity\\\": \\\"Park City\\\",\\n          \\\"residenceStateName\\\": \\\"Utah\\\",\\n          \\\"residenceZipCode\\\": \\\"84098\\\",\\n          \\\"dateOfBirth\\\": \\\"1950-01-01\\\",\\n          \\\"ssn\\\": \\\"999999990\\\",\\n          \\\"annualIncome\\\": 10001,\\n          \\\"employerName\\\": \\\"Test\\\",\\n          \\\"jobTitle\\\": \\\"Test\\\",\\n          \\\"employmentYears\\\": \\\"5\\\",\\n          \\\"employmentMonths\\\": \\\"4\\\"\\n        }\\n      ]\\n    }\\n  ]\\n}\"\n}\n```\n\n```json title=\"Response Format\" jsonSchema\n{\n  \"type\": \"object\",\n  \"properties\": {\n    \"returnCode\": {\n      \"type\": \"string\"\n    },\n    \"projects\": {\n      \"type\": \"array\",\n      \"items\": {\n        \"type\": \"object\",\n        \"properties\": {\n          \"id\": {\n            \"type\": \"string\"\n          },\n          \"hashId\": {\n            \"type\": \"string\"\n          },\n          \"ownerEmail\": {\n            \"type\": \"string\"\n          },\n          \"term\": {\n            \"type\": \"integer\"\n          },\n          \"apr\": {\n            \"type\": \"number\"\n          },\n          \"isACH\": {\n            \"type\": \"boolean\"\n          },\n          \"isCreditAuthorized\": {\n            \"type\": \"boolean\"\n          },\n          \"installStreet\": {\n            \"type\": \"string\"\n          },\n          \"installCity\": {\n            \"type\": \"string\"\n          },\n          \"installStateName\": {\n            \"type\": \"string\"\n          },\n          \"installZipCode\": {\n            \"type\": \"string\"\n          },\n          \"ownerName\": {\n            \"type\": \"string\"\n          },\n          \"productType\": {\n            \"type\": \"string\"\n          },\n          \"installerName\": {\n            \"type\": \"string\"\n          },\n          \"projectCategory\": {\n            \"type\": \"string\"\n          },\n          \"requestedLoanAmount\": {\n            \"type\": \"integer\"\n          },\n          \"amountDrawn\": {\n            \"type\": \"integer\"\n          },\n          \"amountRemaining\": {\n            \"type\": \"integer\"\n          },\n          \"approvedForPayments\": {\n            \"type\": \"boolean\"\n          },\n          \"blockDraw\": {\n            \"type\": \"boolean\"\n          },\n          \"maxAvailable\": {\n            \"type\": \"integer\"\n          },\n          \"drawCount\": {\n            \"type\": \"integer\"\n          },\n          \"drawExpired\": {\n            \"type\": \"boolean\"\n          },\n          \"statusText\": {\n            \"type\": \"string\"\n          },\n          \"itcCutoff\": {\n            \"type\": \"string\"\n          },\n          \"drawAutoApproved\": {\n            \"type\": \"boolean\"\n          },\n          \"applicants\": {\n            \"type\": \"array\",\n            \"items\": {\n              \"type\": \"object\",\n              \"properties\": {\n                \"id\": {\n                  \"type\": \"string\"\n                },\n                \"firstName\": {\n                  \"type\": \"string\"\n                },\n                \"middleInitial\": {\n                  \"type\": \"string\"\n                },\n                \"lastName\": {\n                  \"type\": \"string\"\n                },\n                \"phone\": {\n                  \"type\": \"string\"\n                },\n                \"otherPhone\": {\n                  \"type\": \"string\"\n                },\n                \"email\": {\n                  \"type\": \"string\"\n                },\n                \"isPrimary\": {\n                  \"type\": \"boolean\"\n                },\n                \"mailingStreet\": {\n                  \"type\": \"string\"\n                },\n                \"mailingCity\": {\n                  \"type\": \"string\"\n                },\n                \"mailingStateName\": {\n                  \"type\": \"string\"\n                },\n                \"mailingZipCode\": {\n                  \"type\": \"string\"\n                },\n                \"residenceStreet\": {\n                  \"type\": \"string\"\n                },\n                \"residenceCity\": {\n                  \"type\": \"string\"\n                },\n                \"residenceStateName\": {\n                  \"type\": \"string\"\n                },\n                \"residenceZipCode\": {\n                  \"type\": \"string\"\n                },\n                \"annualIncome\": {\n                  \"type\": \"integer\"\n                },\n                \"employerName\": {\n                  \"type\": \"string\"\n                },\n                \"employmentMonths\": {\n                  \"type\": \"integer\"\n                },\n                \"employmentYears\": {\n                  \"type\": \"integer\"\n                },\n                \"jobTitle\": {\n                  \"type\": \"string\"\n                },\n                \"isCreditRun\": {\n                  \"type\": \"boolean\"\n                }\n              }\n            }\n          }\n        }\n      }\n    }\n  }\n}\n```\n\n### Setting Ownership during creation\n\nYou can set ownership of the Project by including the attribute `\"ownerEmail\"` to the request a the `\"project\"` array level and providing a valid email address of an active user.\n\nIf you provide an invalid or no email address (default), ownership of the Project will be set to the running user, in this case the API user.\n\nPlease note that each user type has different permissions.\n"
# }
# ##### request to SLF CreateProject API docs page (after successful login)
# curl 'https://stoplight.io/api/v1/projects/cHJqOjgyMzc4/table-of-contents' \
#   -H 'accept: */*' \
#   -H 'accept-language: en-US,en;q=0.9' \
#   -H 'authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL3N0b3BsaWdodC5pby9qd3QvY2xhaW1zIjp7IngtaGFzdXJhLWRlZmF1bHQtcm9sZSI6IndvcmtzcGFjZV91c2VyIiwieC1oYXN1cmEtYWxsb3dlZC1yb2xlcyI6WyJ3b3Jrc3BhY2VfdXNlciJdLCJ4LWhhc3VyYS11c2VyLWlkIjoiMTA0MzgyIiwieC1oYXN1cmEtdXNlci1pcC1hZGRyZXNzIjoiMTAuMTYuMi4xMCIsIngtaGFzdXJhLXdvcmtzcGFjZS1pZCI6IjU2NTM3In0sImlhdCI6MTcxNTUzNDM1NCwiZXhwIjoxNzE1NTM0OTU0LCJpc3MiOiJzdG9wbGlnaHQiLCJzdWIiOiIvdXNlcnMvMTA0MzgyIn0.G5mVBQkMTIein7M2H8SSqREc7b4MpoAOUvD2xOTc3uA' \
#   -H 'cache-control: no-cache' \
#   -H 'origin: https://apidocs.slfportal.com' \
#   -H 'pragma: no-cache' \
#   -H 'priority: u=1, i' \
#   -H 'referer: https://apidocs.slfportal.com/' \
#   -H 'sec-ch-ua: "Chromium";v="124", "Google Chrome";v="124", "Not-A.Brand";v="99"' \
#   -H 'sec-ch-ua-mobile: ?0' \
#   -H 'sec-ch-ua-platform: "macOS"' \
#   -H 'sec-fetch-dest: empty' \
#   -H 'sec-fetch-mode: cors' \
#   -H 'sec-fetch-site: cross-site' \
#   -H 'stoplight-elements-version: 2.1.3' \
#   -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36'

# ##### working(?) stoplight API docs page download
# wget --mirror --convert-links --adjust-extension --page-requisites --no-parent \
#   --domains=stoplight.io \
#   --include-directories=/api/v1/projects/cHJqOjgyMzc4/nodes,/api/v1/projects/cHJqOjgyMzc4/table-of-contents \
#   --save-cookies cookies.txt \
#   --keep-session-cookies \
#   --header="Accept: */*" \
#   --header="Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL3N0b3BsaWdodC5pby9qd3QvY2xhaW1zIjp7IngtaGFzdXJhLWRlZmF1bHQtcm9sZSI6IndvcmtzcGFjZV91c2VyIiwieC1oYXN1cmEtYWxsb3dlZC1yb2xlcyI6WyJ3b3Jrc3BhY2VfdXNlciJdLCJ4LWhhc3VyYS11c2VyLWlkIjoiMTA0MzgyIiwieC1oYXN1cmEtdXNlci1pcC1hZGRyZXNzIjoiMTAuMTYuMi4xMCIsIngtaGFzdXJhLXdvcmtzcGFjZS1pZCI6IjU2NTM3In0sImlhdCI6MTcxNTUzNDM1NCwiZXhwIjoxNzE1NTM0OTU0LCJpc3MiOiJzdG9wbGlnaHQiLCJzdWIiOiIvdXNlcnMvMTA0MzgyIn0.G5mVBQkMTIein7M2H8SSqREc7b4MpoAOUvD2xOTc3uA" \
#   --header="stoplight-elements-version: 2.1.3" \
#   --header="stoplight-consumer: ninja" \
#   --header="stoplight-consumer-version: 2023.08.0-stable.10997.git-985872d" \
#   https://stoplight.io/api/v1/projects/cHJqOjgyMzc4/nodes/b87d37ae48a0d-authentication \
#   https://stoplight.io/api/v1/workspaces/d2s6NTY1Mzc/billing \
#   https://stoplight.io/api/v1/projects/cHJqOjgyMzc4/nodes/ZG9jOjE5NzA4Njcw-updating-an-applicant-overview \
#   https://stoplight.io/api/v1/projects/cHJqOjgyMzc4/table-of-contentsi/v1/workspaces/d2s6NTY1Mzc/

# ##### attempt to download all pages from stoplight API docs
# wget --mirror --convert-links --adjust-extension --page-requisites --no-parent \
#     --domains=stoplight.io \
#     --include-directories=/api/v1/projects/cHJqOjgyMzc4/ \
#     --save-cookies cookies.txt \
#     --keep-session-cookies \
#     --header="Accept: */*" \
#     --header="Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL3N0b3BsaWdodC5pby9qd3QvY2xhaW1zIjp7IngtaGFzdXJhLWRlZmF1bHQtcm9sZSI6IndvcmtzcGFjZV91c2VyIiwieC1oYXN1cmEtYWxsb3dlZC1yb2xlcyI6WyJ3b3Jrc3BhY2VfdXNlciJdLCJ4LWhhc3VyYS11c2VyLWlkIjoiMTA0MzgyIiwieC1oYXN1cmEtdXNlci1pcC1hZGRyZXNzIjoiMTAuMTYuOS4xNzEiLCJ4LWhhc3VyYS13b3Jrc3BhY2UtaWQiOiI1NjUzNyJ9LCJpYXQiOjE3MTU1MzUwMDAsImV4cCI6MTcxNTUzNTYwMCwiaXNzIjoic3RvcGxpZ2h0Iiwic3ViIjoiL3VzZXJzLzEwNDM4MiJ9.aj5-1Dt-R4pt1D2mr6lBzowGJnXU52_-g_AdFJl3l68" \
#     --header="stoplight-elements-version: 2.1.3" \
#     --header="stoplight-consumer: ninja" \
#     --header="stoplight-consumer-version: 2023.08.0-stable.10997.git-985872d" \
#     https://stoplight.io/api/v1/projects/cHJqOjgyMzc4/nodes/b87d37ae48a0d-authentication \
#     https://stoplight.io/api/v1/projects/cHJqOjgyMzc4/ \
#     https://stoplight.io/api/v1/workspaces/d2s6NTY1Mzc/
# # ╭─    ~/Downloads ······················································································································································································································································································································································································································································· ✔  at 10:31:03 AM  ─╮
# # ╰─ curl 'https://stoplight.io/api/v1/projects/cHJqOjgyMzc4/table-of-contents?branch=v1.0' \                                                                                                                                                                                                                                                                                                                                                                                                         ─╯
# #   -H 'accept: */*' \
# #   -H 'accept-language: en-US,en;q=0.9' \
# #   -H 'authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL3N0b3BsaWdodC5pby9qd3QvY2xhaW1zIjp7IngtaGFzdXJhLWRlZmF1bHQtcm9sZSI6IndvcmtzcGFjZV91c2VyIiwieC1oYXN1cmEtYWxsb3dlZC1yb2xlcyI6WyJ3b3Jrc3BhY2VfdXNlciJdLCJ4LWhhc3VyYS11c2VyLWlkIjoiMTA0MzgyIiwieC1oYXN1cmEtdXNlci1pcC1hZGRyZXNzIjoiMTAuMTYuOS4xNzEiLCJ4LWhhc3VyYS13b3Jrc3BhY2UtaWQiOiI1NjUzNyJ9LCJpYXQiOjE3MTU1MzUwMDAsImV4cCI6MTcxNTUzNTYwMCwiaXNzIjoic3RvcGxpZ2h0Iiwic3ViIjoiL3VzZXJzLzEwNDM4MiJ9.aj5-1Dt-R4pt1D2mr6lBzowGJnXU52_-g_AdFJl3l68' \
# #   -H 'cache-control: no-cache' \
# #   -H 'origin: https://apidocs.slfportal.com' \
# #   -H 'pragma: no-cache' \
# #   -H 'priority: u=1, i' \
# #   -H 'referer: https://apidocs.slfportal.com/' \
# #   -H 'sec-ch-ua: "Chromium";v="124", "Google Chrome";v="124", "Not-A.Brand";v="99"' \
# #   -H 'sec-ch-ua-mobile: ?0' \
# #   -H 'sec-ch-ua-platform: "macOS"' \
# #   -H 'sec-fetch-dest: empty' \
# #   -H 'sec-fetch-mode: cors' \
# #   -H 'sec-fetch-site: cross-site' \
# #   -H 'stoplight-elements-version: 2.1.3' \
# #   -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36'

# # HTTP/2 200
# # date: Sun, 12 May 2024 17:31:04 GMT
# # content-type: application/json; charset=utf-8
# # cf-ray: 882c23e8583e7af7-SJC
# # cf-cache-status: DYNAMIC
# # access-control-allow-origin: *
# # etag: W/"1665-Goddol7Ek/m7vjWKHalDsKw1rrw"
# # set-cookie: GCLB=CL2Ei7bTo4-YmAEQAw; path=/; HttpOnly
# # via: 1.1 google
# # access-control-allow-methods: GET, HEAD, PUT, PATCH, POST, DELETE
# # access-control-expose-headers: Link
# # alt-svc: h3=":443"; ma=86400
# # x-request-id: fec3a0f9-1caf-48d1-963a-60238f2e73b5
# # set-cookie: __cf_bm=KAV0amdvS6oPXoi1nUhrYPxii4nyX4C8pLriuUFSjuE-1715535064-1.0.1.1-VUxj0zqJUkUzEZqVl.0JXfBF9yMzfz.pExIe84aLQVLsPFgMPbp7fK3swtkZkckrTa.x0jRmMwbUKyQVOwDSBA; path=/; expires=Sun, 12-May-24 18:01:04 GMT; domain=.stoplight.io; HttpOnly; Secure; SameSite=None
# # server: cloudflare

# # {
# #     "hide_powered_by": false,
# #     "collapseTableOfContents": false,
# #     "items": [
# #         {
# #             "id": "4b402d5ab3edd",
# #             "title": "Solar API Documentation",
# #             "type": "article",
# #             "slug": "4b402d5ab3edd-welcome",
# #             "meta": ""
# #         },
# #         {
# #             "id": "b87d37ae48a0d",
# #             "title": "Authentication",
# #             "type": "article",
# #             "slug": "b87d37ae48a0d-authentication",
# #             "meta": ""
# #         },
# #         {
# #             "title": "Create a Project"
# #         },
# #         {
# #             "id": "ZG9jOjE5NzA4NjY4",
# #             "title": "Create Project",
# #             "type": "article",
# #             "slug": "ZG9jOjE5NzA4NjY4-create-project-overview",
# #             "meta": ""
# #         },
# #         {
# #             "id": "ZG9jOjE5NzA4Njcw",
# #             "title": "Updating an Applicant",
# #             "type": "article",
# #             "slug": "ZG9jOjE5NzA4Njcw-updating-an-applicant-overview",
# #             "meta": ""
# #         },
# #         {
# #             "title": "Quotes"
# #         },
# #         {
# #             "id": "e47da418be939",
# #             "title": "List Products",
# #             "type": "article",
# #             "slug": "e47da418be939-list-products-overview",
# #             "meta": ""
# #         },
# #         {
# #             "id": "ZG9jOjE5NzA4Njcy",
# #             "title": "Add Quote",
# #             "type": "article",
# #             "slug": "ZG9jOjE5NzA4Njcy-add-quote-overview",
# #             "meta": ""
# #         },
# #         {
# #             "id": "ZG9jOjE5NzA4Njcz",
# #             "title": "Quote Syncing",
# #             "type": "article",
# #             "slug": "ZG9jOjE5NzA4Njcz-quote-syncing-overview",
# #             "meta": ""
# #         },
# #         {
# #             "id": "11a4d4d9c0d91",
# #             "title": "QuickQuote",
# #             "type": "article",
# #             "slug": "11a4d4d9c0d91-quick-quote-overview",
# #             "meta": ""
# #         },
# #         {
# #             "title": "System Design"
# #         },
# #         {
# #             "id": "ZG9jOjE5NzA4OTc3",
# #             "title": "Get Equipment",
# #             "type": "article",
# #             "slug": "ZG9jOjE5NzA4OTc3-get-equipment-overview",
# #             "meta": ""
# #         },
# #         {
# #             "id": "ZG9jOjE5NzA4OTc4",
# #             "title": "Create System Design",
# #             "type": "article",
# #             "slug": "ZG9jOjE5NzA4OTc4-system-design-overview",
# #             "meta": ""
# #         },
# #         {
# #             "title": "Credit"
# #         },
# #         {
# #             "id": "96cb6220c0cfb",
# #             "title": "Submit Credit",
# #             "type": "article",
# #             "slug": "96cb6220c0cfb-submit-credit-overview",
# #             "meta": ""
# #         },
# #         {
# #             "id": "ZG9jOjE5NzA4Njc2",
# #             "title": "Credit Syncing",
# #             "type": "article",
# #             "slug": "ZG9jOjE5NzA4Njc2-credit-syncing-overview",
# #             "meta": ""
# #         },
# #         {
# #             "title": "Generate Loan Documents"
# #         },
# #         {
# #             "id": "ZG9jOjE5NzA4Njc3",
# #             "title": "Loan Documents",
# #             "type": "article",
# #             "slug": "ZG9jOjE5NzA4Njc3-request-loan-documents-overview",
# #             "meta": ""
# #         },
# #         {
# #             "id": "ZG9jOjE5NzA4Njc4",
# #             "title": "In Person Loan Documents",
# #             "type": "article",
# #             "slug": "ZG9jOjE5NzA4Njc4-request-loan-documents-in-person-overview",
# #             "meta": ""
# #         },
# #         {
# #             "title": "Status"
# #         },
# #         {
# #             "id": "3229b9b1e886c",
# #             "title": "Event",
# #             "type": "article",
# #             "slug": "3229b9b1e886c-status-event-overview",
# #             "meta": ""
# #         },
# #         {
# #             "id": "76bc616cf5d74",
# #             "title": "Pull",
# #             "type": "article",
# #             "slug": "76bc616cf5d74-status-pull-overview",
# #             "meta": ""
# #         },
# #         {
# #             "title": "Prequalification"
# #         },
# #         {
# #             "id": "ZG9jOjE5NzA4Njgy",
# #             "title": "Prequalification",
# #             "type": "article",
# #             "slug": "ZG9jOjE5NzA4Njgy-prequalification-overview",
# #             "meta": ""
# #         },
# #         {
# #             "title": "Preapproval"
# #         },
# #         {
# #             "title": "Change Order"
# #         },
# #         {
# #             "id": "ZG9jOjE5NzA4OTkx",
# #             "title": "Submit Change Order",
# #             "type": "article",
# #             "slug": "ZG9jOjE5NzA4OTkx-submit-change-order-overview",
# #             "meta": ""
# #         },
# #         {
# #             "id": "ZG9jOjE5NzA4OTky",
# #             "title": "Cancel Change Order",
# #             "type": "article",
# #             "slug": "ZG9jOjE5NzA4OTky-cancel-change-order-overview",
# #             "meta": ""
# #         },
# #         {
# #             "title": "Operations"
# #         },
# #         {
# #             "id": "ZG9jOjE5NzA4OTkz",
# #             "title": "Fetch Required Documents",
# #             "type": "article",
# #             "slug": "ZG9jOjE5NzA4OTkz-fetch-required-documents-overview",
# #             "meta": ""
# #         },
# #         {
# #             "id": "ZG9jOjE5NzA4OTk0",
# #             "title": "Upload Documents",
# #             "type": "article",
# #             "slug": "ZG9jOjE5NzA4OTk0-file-upload-overview",
# #             "meta": ""
# #         },
# #         {
# #             "id": "ZG9jOjE5NzA4OTk1",
# #             "title": "Upload Stipulation Documents",
# #             "type": "article",
# #             "slug": "ZG9jOjE5NzA4OTk1-upload-stipulation-documents-overview",
# #             "meta": ""
# #         },
# #         {
# #             "id": "ZG9jOjE5NzA4OTk2",
# #             "title": "Fetch Project Documents",
# #             "type": "article",
# #             "slug": "ZG9jOjE5NzA4OTk2-fetch-project-documents-overview",
# #             "meta": ""
# #         },
# #         {
# #             "id": "ZG9jOjE5NzA4OTk3",
# #             "title": "Request Milestones",
# #             "type": "article",
# #             "slug": "ZG9jOjE5NzA4OTk3-request-milestone-overview",
# #             "meta": ""
# #         },
# #         {
# #             "title": "Required Disclosures"
# #         },
# #         {
# #             "title": "General Disclosures",
# #             "items": [
# #                 {
# #                     "id": "edb02d27b7c03",
# #                     "title": "General Disclosures",
# #                     "type": "article",
# #                     "slug": "edb02d27b7c03-general-disclosures",
# #                     "meta": ""
# #                 },
# #                 {
# #                     "id": "ZG9jOjE5NzA4Njk1",
# #                     "title": "California Consumer Privacy Act",
# #                     "type": "article",
# #                     "slug": "ZG9jOjE5NzA4Njk1-california-consumer-privacy-act",
# #                     "meta": ""
# #                 },
# #                 {
# #                     "id": "ZG9jOjE5NzA4Njk2",
# #                     "title": "Privacy Policy and Revocation of Consent",
# #                     "type": "article",
# #                     "slug": "ZG9jOjE5NzA4Njk2-privacy-policy-and-revocation-of-consent",
# #                     "meta": ""
# #                 },
# #                 {
# #                     "id": "ZG9jOjE5NzA4Njk3",
# #                     "title": "Phone Disclosure",
# #                     "type": "article",
# #                     "slug": "ZG9jOjE5NzA4Njk3-phone-disclosure",
# #                     "meta": ""
# #                 }
# #             ]
# #         },
# #         {
# #             "title": "Credit Related Disclosures",
# #             "items": [
# #                 {
# #                     "id": "faf3187b39411",
# #                     "title": "Credit Disclosures",
# #                     "type": "article",
# #                     "slug": "faf3187b39411-required-disclosures",
# #                     "meta": ""
# #                 },
# #                 {
# #                     "id": "c4934d001d2fc",
# #                     "title": "Credit Decision Screens",
# #                     "type": "article",
# #                     "slug": "c4934d001d2fc-credit-decision-screens-overview",
# #                     "meta": ""
# #                 }
# #             ]
# #         },
# #         {
# #             "title": "Prequalification Related Disclosures",
# #             "items": [
# #                 {
# #                     "id": "0c11fb60183c9",
# #                     "title": "Prequalification Disclosures",
# #                     "type": "article",
# #                     "slug": "0c11fb60183c9-required-disclosures",
# #                     "meta": ""
# #                 }
# #             ]
# #         },
# #         {
# #             "title": "Miscellaneous Functionality"
# #         },
# #         {
# #             "id": "ZG9jOjE5NzA4Njg2",
# #             "title": "Spanish Support",
# #             "type": "article",
# #             "slug": "ZG9jOjE5NzA4Njg2-spanish-support-overview",
# #             "meta": ""
# #         },
# #         {
# #             "id": "ZG9jOjE5NzA4Njg3",
# #             "title": "Sunlight Rewards",
# #             "type": "article",
# #             "slug": "ZG9jOjE5NzA4Njg3-sunlight-rewards-overview",
# #             "meta": ""
# #         },
# #         {
# #             "id": "9c93e0611a65d",
# #             "title": "Change Project Owner",
# #             "type": "article",
# #             "slug": "9c93e0611a65d-change-project-owner-overview",
# #             "meta": ""
# #         },
# #         {
# #             "id": "ZG9jOjE5NzA4Njg5",
# #             "title": "List All Projects and Search",
# #             "type": "article",
# #             "slug": "ZG9jOjE5NzA4Njg5-list-all-projects-and-search-overview",
# #             "meta": ""
# #         },
# #         {
# #             "title": "Testing"
# #         },
# #         {
# #             "id": "ZG9jOjE5NzA4Njkw",
# #             "title": "Test Data",
# #             "type": "article",
# #             "slug": "ZG9jOjE5NzA4Njkw-test-data",
# #             "meta": ""
# #         },
# #         {
# #             "id": "ecb0040eaf34a",
# #             "title": "Automated Testing",
# #             "type": "article",
# #             "slug": "ecb0040eaf34a-automated-testing-overview",
# #             "meta": ""
# #         },
# #         {
# #             "title": "Thesaurus"
# #         },
# #         {
# #             "id": "ZG9jOjE5NzA4Njky",
# #             "title": "Unified JSON Response",
# #             "type": "article",
# #             "slug": "ZG9jOjE5NzA4Njky-unified-json-response",
# #             "meta": ""
# #         },
# #         {
# #             "id": "ZG9jOjE5NzA4Njkz",
# #             "title": "Regular Expressions",
# #             "type": "article",
# #             "slug": "ZG9jOjE5NzA4Njkz-sunlight-financial-regular-expressions",
# #             "meta": ""
# #         }
# #     ]
# # }
# # ╭─    ~/Downloads ······················································································································································································································································································································································································································································· ✔  at 10:31:04 AM  ─╮
# # ╰─ curl 'https://stoplight.io/api/v1/projects/cHJqOjgyMzc4/?branch=v1.0' \                                                                                                                                                                                                                                                                                                                                                                                                                          ─╯
# #   -H 'accept: */*' \
# #   -H 'accept-language: en-US,en;q=0.9' \
# #   -H 'authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL3N0b3BsaWdodC5pby9qd3QvY2xhaW1zIjp7IngtaGFzdXJhLWRlZmF1bHQtcm9sZSI6IndvcmtzcGFjZV91c2VyIiwieC1oYXN1cmEtYWxsb3dlZC1yb2xlcyI6WyJ3b3Jrc3BhY2VfdXNlciJdLCJ4LWhhc3VyYS11c2VyLWlkIjoiMTA0MzgyIiwieC1oYXN1cmEtdXNlci1pcC1hZGRyZXNzIjoiMTAuMTYuOS4xNzEiLCJ4LWhhc3VyYS13b3Jrc3BhY2UtaWQiOiI1NjUzNyJ9LCJpYXQiOjE3MTU1MzUwMDAsImV4cCI6MTcxNTUzNTYwMCwiaXNzIjoic3RvcGxpZ2h0Iiwic3ViIjoiL3VzZXJzLzEwNDM4MiJ9.aj5-1Dt-R4pt1D2mr6lBzowGJnXU52_-g_AdFJl3l68' \
# #   -H 'cache-control: no-cache' \
# #   -H 'origin: https://apidocs.slfportal.com' \
# #   -H 'pragma: no-cache' \
# #   -H 'priority: u=1, i' \
# #   -H 'referer: https://apidocs.slfportal.com/' \
# #   -H 'sec-ch-ua: "Chromium";v="124", "Google Chrome";v="124", "Not-A.Brand";v="99"' \
# #   -H 'sec-ch-ua-mobile: ?0' \
# #   -H 'sec-ch-ua-platform: "macOS"' \
# #   -H 'sec-fetch-dest: empty' \
# #   -H 'sec-fetch-mode: cors' \
# #   -H 'sec-fetch-site: cross-site' \
# #   -H 'stoplight-elements-version: 2.1.3' \
# #   -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36'

# # HTTP/2 200
# # date: Sun, 12 May 2024 17:31:18 GMT
# # content-type: application/json; charset=utf-8
# # cf-ray: 882c243d69609e4d-SJC
# # cf-cache-status: DYNAMIC
# # access-control-allow-origin: *
# # etag: W/"43f-AK6OBMIkRUUUQZHGHKFS8zo/L8o"
# # set-cookie: GCLB=CLe-s82U-9SjbhAD; path=/; HttpOnly
# # via: 1.1 google
# # access-control-allow-methods: GET, HEAD, PUT, PATCH, POST, DELETE
# # access-control-expose-headers: Link
# # alt-svc: h3=":443"; ma=86400
# # x-request-id: 260f1041-6264-4f93-b404-42a8eeb510cc
# # set-cookie: __cf_bm=h0h9pNcd3YjKe1YcE6giu6_GW6nxLueDHPvGg4PcpNs-1715535078-1.0.1.1-z4ybHZP2P15TjaoUFbh3kmwudrsvMHIZzONskMgJ4b4F_VQRxZB2W84FQfPDgM1vAMbiKpandpP6SeNyg016Ow; path=/; expires=Sun, 12-May-24 18:01:18 GMT; domain=.stoplight.io; HttpOnly; Secure; SameSite=None
# # server: cloudflare

# # {
# #     "id": "cHJqOjgyMzc4",
# #     "slug": "solar-api-documentation",
# #     "name": "Solar API Documentation",
# #     "type": "web",
# #     "flavor": "design",
# #     "visibility": "internal",
# #     "created_at": "2021-08-30T22:57:06.01318+00:00",
# #     "updated_at": "2021-09-10T20:52:31.004414+00:00",
# #     "is_design_library": false,
# #     "default_branch": {
# #         "id": "YnI6MTI5NTQyMw",
# #         "name": "v1.0",
# #         "slug": "v1.0",
# #         "commit_hash": "952fee97ccde7",
# #         "is_default": true,
# #         "is_published": true,
# #         "updated_at": "2024-02-26T17:08:28.008085+00:00",
# #         "node_counts": {
# #             "total_count": 48,
# #             "article_count": 42,
# #             "schema_count": 0,
# #             "api_count": 3,
# #             "operation_count": 0
# #         }
# #     },
# #     "external_id": null,
# #     "presentation": {
# #         "icon": null,
# #         "color": null
# #     },
# #     "my_role": "guest",
# #     "my_permissions": [
# #         "project_read",
# #         "project_leave",
# #         "project_published_branch_read"
# #     ],
# #     "pinned": false,
# #     "owner": {
# #         "id": "dXNyOjkyODU1",
# #         "display_name": "Olaf van Yperen",
# #         "avatar_url": "https://gravatar.com/avatar/475bb64454d7fddcdb29f1938618b319?s=250"
# #     },
# #     "default_branch_id": "YnI6MTI5NTQyMw",
# #     "workspace": {
# #         "id": "d2s6NTY1Mzc",
# #         "name": "sunlightfinancial",
# #         "slug": "sunlightfinancial"
# #     },
# #     "is_default_style_guide": false,
# #     "workspace_integration": null,
# #     "auto_invite_committers": false
# # }
# # ╭─    ~/Downloads ·············································································································································································································································································································································································································································· ✔  NORMAL  at 10:31:18 AM  ─╮
# # ╰─                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  ─╯

