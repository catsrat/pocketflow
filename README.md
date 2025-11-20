# PocketFlow — Expense Tracker (MVP scaffold)

This repository is a generated scaffold for a Flutter cross-platform expense tracker.
It includes:
- Local persistence with sqflite
- Add / Edit / Delete expenses
- Category management
- CSV export and share
- Simple analytics (pie + bar charts using fl_chart)
- GitHub Actions CI examples for Android and iOS
- Store metadata templates and privacy policy

## How to run locally

1. Install Flutter SDK (stable) and set up your environment.
2. From project root:
   ```bash
   flutter pub get
   flutter run
   ```
3. To run tests:
   ```bash
   flutter test
   flutter test integration_test/app_test.dart
   ```

## How I can help next
- I can prepare Play Store listing copy, screenshots, and a submission checklist.
- I can guide you through creating signing keys and setting up secrets in GitHub Actions.
- I can generate sample screenshots/mockups for store listings (PNG).


## Scripts & CI

- Use `./scripts/git_push.sh YOUR_GH_USERNAME` to create and push to GitHub (requires gh CLI).
- Add GitHub Secrets as described in `CI_SECRETS.md` to enable automatic signed builds.
- The release workflow will produce artifacts you can download from GitHub Actions or configure further to auto-upload to Play Store / TestFlight.
