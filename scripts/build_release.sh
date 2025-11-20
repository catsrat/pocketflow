#!/usr/bin/env bash
set -e
# Android AAB
echo "Building Android AAB (debug signing). Replace with your keystore for production."
flutter pub get
flutter build appbundle --no-shrink --release
echo "AAB built at build/app/outputs/bundle/release/app-release.aab (if using default build)"
# iOS (no codesign)
echo "Building iOS (no codesign). You must run on macOS runner and configure signing for App Store upload."
flutter build ipa --no-codesign || echo "flutter build ipa failed; try flutter build ios --no-codesign on macOS"
