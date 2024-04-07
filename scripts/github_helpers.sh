#!/bin/bash

gh_org_repos_sync() {
    set -x
    # Replace ORG_NAME with your GitHub organization name
    # Replace YOUR_GITHUB_ACCESS_TOKEN with your GitHub access token
    GITHUB_ORG_NAME=${GITHUB_ORG_NAME:-"GITHUB_ORG_NAME"}
    GITHUB_TOKEN=${GITHUB_TOKEN:-"YOUR_GITHUB_ACCESS_TOKEN"}
    WORKSPACE_BASE_DIR=${WORKSPACE_BASE_DIR:-"$HOME/workspace/ansa"} # Base directory to store all repos

    # Fetch the list of repositories for the organization
    REPOS=$(curl -H "Authorization: token $GITHUB_TOKEN" \
        "https://api.github.com/orgs/$GITHUB_ORG_NAME/repos?per_page=200" | jq -r '.[].ssh_url')

    # echo "(REPOS : $REPOS)"

    # Convert multiline string into an array
    readarray -t REPO_ARRAY <<< "$REPOS"
    # echo "(REPO_ARRAY : $REPO_ARRAY)"

    # To verify, you can print all elements of the array
    # for repo in "${REPO_ARRAY[@]}"; do
    #     echo "########### (REPO_ARRAY repo : $repo)"
    # done

    # Loop through each repository URL
    for REPO in $REPOS; do
        # Extract the repository name from the URL
        REPO_NAME=$(echo "$REPO" | cut -d'/' -f2 | cut -d'.' -f1)
        REPO_DIR="$WORKSPACE_BASE_DIR/$REPO_NAME"
        echo "--- repo : $REPO --- repo name : $REPO_NAME --- repo dir : $REPO_DIR"

        # Check if the repository directory exists
        if [ -d "$REPO_DIR" ]; then
            # Repository exists, navigate to it
            echo "Updating $REPO_NAME..."
            cd "$REPO_DIR"

            # Check for untracked or uncommitted changes
            if ! git diff --quiet || ! git diff --cached --quiet; then
                # Changes detected, stash them
                echo "Stashing changes in $REPO_NAME..."
                git stash push -m "Auto-stashed on $(date)"
            fi

            # Fetch all branches and pull the current branch
            git fetch --all
            git pull

            # Reapply the latest stash if there was one
            if git stash list | grep -q "Auto-stashed on"; then
                echo "Re-applying latest stash in $REPO_NAME..."
                git stash pop
            fi
        else
            # Repository doesn't exist, clone it
            echo "Cloning $REPO_NAME..."
            git clone "$REPO" "$REPO_DIR"
        fi
    done
}
