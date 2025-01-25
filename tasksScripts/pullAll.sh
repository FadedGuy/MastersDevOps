#!/bin/bash

fetch_and_pull() {
    local repo_path="$1"

    # Check if the directory exists
    if [ -d "$repo_path" ]; then
        echo "Fetching and pulling for repository: $repo_path"
        cd "$repo_path" || {
            echo "Failed to change directory to $repo_path."
            exit 1
        }
        git fetch --all --progress -v
        git pull --all --progress -v
    else
        echo "Directory $repo_path does not exist. Skipping."
    fi
}

# Fetch and pull for MastersDevOps (current directory)
fetch_and_pull "$(pwd)"

# Fetch and pull for Vault
fetch_and_pull "/mnt/d/Documents/Vault/"
