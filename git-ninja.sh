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

# Clear screen and print heade
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

echo -e "${CYAN}Checking Git repository...${RESET}"

set -e

# Check if the current directory is a Git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo -e "${RED}❌ Error:${RESET} This is not a Git repository."
    exit 1
fi

current_branch=$(git rev-parse --abbrev-ref HEAD)

echo -e "🔢 ${CYAN}Current branch:${RESET} $current_branch"

# Stage all changes
git add .

echo -e "${GREEN}✅ Changes staged.${RESET}"

# Commit changes
default_message="Auto-commit: $(date +"%Y-%m-%d %H:%M:%S")"
git commit -m "$default_message"

echo -e "${GREEN}✅ Changes committed with message: '$default_message'.${RESET}"

# Check if the branch has an upstream
if ! git rev-parse --abbrev-ref --symbolic-full-name @{u} > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  No upstream detected. Setting upstream...${RESET}"
    git push --set-upstream origin "$current_branch"
else
    start_loading "Pushing changes to remote..."
    git push
    stop_loading "Changes pushed successfully"
fi

echo -e "✅ ${GREEN}All tasks completed successfully!${RESET}"
echo -e "${MAGENTA}🎉 Mission Accomplished! Keep coding like a ninja! 🚀${RESET}"
