#!/bin/bash

# ============================
# Git Ninja - Automate Git Like a Pro!
# ============================

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
CYAN="\033[36m"
MAGENTA="\033[35m"
BOLD="\033[1m"
RESET="\033[0m"

loading_animation() {
    local msg=$1
    local delay=0.1
    local spinner=( '🌑' '🌒' '🌓' '🌔' '🌕' '🌖' '🌗' '🌘' )
    while true; do
        for i in "${spinner[@]}"; do
            printf "\r${MAGENTA}${BOLD}$i $msg${RESET}"
            sleep $delay
        done
    done
}

start_loading() {
    loading_animation "$1" &
    LOADING_PID=$!
    disown
}

stop_loading() {
    kill "$LOADING_PID" > /dev/null 2>&1
    printf "\r${GREEN}${BOLD}✔ $1${RESET}\n"
}

# Clear screen and print header
clear
cat << EOF

 ██████╗ ██╗████████╗    ███╗   ██╗██╗███╗   ██╗     ██╗ █████╗ 
██╔════╝ ██║╚══██╔══╝    ████╗  ██║██║████╗  ██║     ██║██╔══██╗
██║  ███╗██║   ██║       ██╔██╗ ██║██║██╔██╗ ██║     ██║███████║
██║   ██║██║   ██║       ██║╚██╗██║██║██║╚██╗██║██   ██║██╔══██║
╚██████╔╝██║   ██║       ██║ ╚████║██║██║ ╚████║╚█████╔╝██║  ██║
 ╚═════╝ ╚═╝   ╚═╝       ╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚════╝ ╚═╝  ╚═╝
                                                                
EOF

echo -e "Silent as a shadow, swift as the wind. Automate Git like a true ninja! ⚡"
echo -e "🔥 ${GREEN}${BOLD}Welcome to Git Ninja!${RESET} 🚀"
echo -e "${CYAN}Streamline your commits, branches, and more with ease.${RESET}"

set -e

# Check if the current directory is a Git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo -e "${RED}❌ Error:${RESET} This is not a Git repository."
    exit 1
fi

# Ask user whether to pull or push
echo -e "What do you want to do?"
read -p "Type 'push' to push changes or 'pull' to pull changes: " action

action=${action,,} # Convert to lowercase

if [[ "$action" == "pull" ]]; then
    read -p "Enter the branch name you want to pull from: " branch
    start_loading "Pulling changes from $branch..."
    git pull origin "$branch"
    stop_loading "Pull completed successfully"
    exit 0
fi

# Proceed with push process
if ! git remote get-url origin > /dev/null 2>&1; then
    echo -e "${RED}❌ Error:${RESET} No remote repository configured. Please add a remote origin first."
    exit 1
fi

start_loading "Fetching repository information..."
repo_name=$(basename "$(git rev-parse --show-toplevel)")
remote_url=$(git remote get-url origin)
current_branch=$(git rev-parse --abbrev-ref HEAD)
stop_loading "Repository information retrieved"

echo -e "🗂️  ${CYAN}Repository:${RESET} $repo_name"
echo -e "🌐 ${CYAN}Remote URL:${RESET} $remote_url"
echo -e "🔢 ${CYAN}Current branch:${RESET} $current_branch"

start_loading "Pushing changes to remote..."
git push -u origin "$current_branch"
stop_loading "Push completed successfully"

echo -e "✅ ${GREEN}All tasks completed successfully"
echo -e "${MAGENTA}🎉 Mission Accomplished! Keep coding like a ninja! 🚀${RESET}"
