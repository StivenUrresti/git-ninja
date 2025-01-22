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

# Check if a remote repository is configured
if ! git remote get-url origin > /dev/null 2>&1; then
    echo -e "${RED}❌ Error:${RESET} No remote repository configured. Please add a remote origin first."
    exit 1
fi

VALID_BRANCHES=("main" "master" "dev")

start_loading "Fetching repository information..."
repo_name=$(basename "$(git rev-parse --show-toplevel)")
remote_url=$(git remote get-url origin)
current_branch=$(git rev-parse --abbrev-ref HEAD)
stop_loading "Repository information retrieved"

echo -e "🗂️  ${CYAN}Repository:${RESET} $repo_name"
echo -e "🌐 ${CYAN}Remote URL:${RESET} $remote_url"
echo -e "🔢 ${CYAN}Current branch:${RESET} $current_branch"

if [[ ! " ${VALID_BRANCHES[@]} " =~ " ${current_branch} " ]]; then
    echo -e "${YELLOW}⚠️  Warning:${RESET} You are not on a valid branch (${VALID_BRANCHES[*]})."
    read -p "Do you want to proceed anyway? (y/n) [y]: " proceed
    proceed=${proceed:-y}
    if [[ "$proceed" != "y" ]]; then
        echo -e "${RED}❌ Exiting.${RESET} Please switch to one of the valid branches."
        exit 1
    fi
fi

untracked_files=$(git ls-files --others --exclude-standard)
if [[ -n "$untracked_files" ]]; then
    echo -e "${YELLOW}⚠️  Untracked files detected:${RESET}"
    echo "$untracked_files"
    read -p "Do you want to add them to staging? (y/n) [n]: " add_untracked
    add_untracked=${add_untracked:-n}
    if [[ "$add_untracked" == "y" ]]; then
        git add $untracked_files
        echo -e "${GREEN}✅ Untracked files added to staging.${RESET}"
    else
        echo -e "${RED}❌ Skipping untracked files.${RESET}"
    fi
fi

unstaged_changes=$(git diff --stat)
if [[ -n "$unstaged_changes" ]]; then
    echo -e "${YELLOW}⚠️  Unstaged changes detected:${RESET}"
    echo "$unstaged_changes"
    read -p "Do you want to stage them? (y/n) [y]: " stage_changes
    stage_changes=${stage_changes:-y}
    if [[ "$stage_changes" == "y" ]]; then
        git add .
        echo -e "${GREEN}✅ Changes staged.${RESET}"
    else
        echo -e "${RED}❌ Skipping unstaged changes.${RESET}"
        exit 1
    fi
fi

uncommitted_changes=$(git diff --cached --stat)
if [[ -n "$uncommitted_changes" ]]; then
    echo -e "${YELLOW}⚠️  Uncommitted changes detected:${RESET}"
    echo "$uncommitted_changes"
    read -p "Do you want to commit them? (y/n) [y]: " commit_changes
    commit_changes=${commit_changes:-y}
    if [[ "$commit_changes" == "y" ]]; then
        read -p "Enter your commit message: " user_commit_message
        git commit -m "$user_commit_message"
        echo -e "${GREEN}✅ Changes committed.${RESET}"
    else
        echo -e "${RED}❌ Commit cancelled.${RESET}"
        exit 1
    fi
fi

read -p "🔖 Do you want to tag this commit? (Optional, press Enter to skip): " tag
if [[ -n "$tag" ]]; then
    git tag "$tag"
    echo -e "${GREEN}✅ Tag '${BOLD}$tag${RESET}${GREEN}' added to commit.${RESET}"
fi

check_upstream() {
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    upstream=$(git rev-parse --abbrev-ref "$current_branch@{u}" 2>/dev/null)
    
    if [ -z "$upstream" ]; then
        echo -e "${YELLOW}⚠️  No upstream branch found for ${current_branch}.${RESET}"
        echo -e "${CYAN}Setting upstream to origin/${current_branch}.${RESET}"
        git push --set-upstream origin "$current_branch"
    else
        echo -e "${GREEN}✔ Upstream branch is already set for ${current_branch}.${RESET}"
    fi
}

check_upstream

read -p "⬆️  Push changes to remote? (y/n) [y]: " push_changes
push_changes=${push_changes:-y}
if [[ "$push_changes" == "y" ]]; then
    start_loading "Pushing changes to remote..."
    git push
else
    echo -e "${RED}❌ Push cancelled.${RESET}"
fi

echo -e "✅ ${GREEN}All tasks completed successfully"
echo -e "${MAGENTA}🎉 Mission Accomplished! Keep coding like a ninja! 🚀${RESET}"
