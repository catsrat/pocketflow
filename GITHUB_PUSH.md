# How to push this project to GitHub

Quick method (requires GitHub CLI `gh`):

1. Install GitHub CLI: https://cli.github.com/
2. Run:
   ```bash
   ./scripts/git_push.sh YOUR_GITHUB_USERNAME pocketflow
   ```

Manual method:

1. Create a new repository on GitHub via the website.
2. Run the following in project root:
   ```bash
   git init
   git add .
   git commit -m "chore: initial PocketFlow MVP polished"
   git remote add origin GIT_REMOTE_URL
   git branch -M main
   git push -u origin main
   ```

Notes:
- Don't commit sensitive files like keystores or Google credentials.
- Use GitHub Secrets to store credentials for CI builds (see README and .github workflows).
