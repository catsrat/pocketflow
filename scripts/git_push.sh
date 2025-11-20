#!/usr/bin/env bash
set -e
if [ -z "$1" ]; then
  echo "Usage: ./scripts/git_push.sh <github-username> [repo-name]"
  exit 1
fi
GH_USER=$1
REPO_NAME=${2:-pocketflow}
git init
git add .
git commit -m "chore: initial PocketFlow MVP polished"
if command -v gh >/dev/null 2>&1; then
  echo "Creating repo using gh CLI..."
  gh repo create $GH_USER/$REPO_NAME --public --source=. --remote=origin --push
else
  echo "gh CLI not found. Create a new repo on GitHub and paste the remote URL."
  echo "Then run:
  git remote add origin <GIT_REMOTE_URL>
  git branch -M main
  git push -u origin main"
fi
