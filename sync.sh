#!/bin/bash
# Agent Hub Sync Script
# Run this before starting work to pull latest changes
# Run this after finishing work to push your changes

set -e

HUB_DIR="$HOME/agent-hub"

# Check if repo exists
if [ ! -d "$HUB_DIR/.git" ]; then
    echo "Cloning agent-hub..."
    git clone https://github.com/kampakilla007/agent-hub.git "$HUB_DIR"
fi

cd "$HUB_DIR"

# Pull latest
echo "Pulling latest changes..."
git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || echo "No remote changes"

# Show status
echo ""
echo "Agent Hub Status:"
git status --short

# Auto-commit and push if there are changes
if [ -n "$(git status --porcelain)" ]; then
    echo ""
    read -p "Push changes? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git add -A
        git commit -m "Update from $(hostname) at $(date '+%Y-%m-%d %H:%M')"
        git push
        echo "Changes pushed!"
    fi
fi

echo ""
echo "Done! Your agents are up to date."
