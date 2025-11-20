# Release Checklist — PocketFlow MVP

## Android (Play Store)
1. Create a Google Play Console account and app entry.
2. Generate a release keystore (if you don't have):
   ```bash
   keytool -genkey -v -keystore pocketflow-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias pocketflow-key
   ```
3. Add signing config to `android/app/build.gradle` and place keystore in safe location.
4. Build AAB:
   ```bash
   flutter build appbundle --release
   ```
5. Upload the `.aab` to Play Console > Release > Production (or internal testing first).
6. Complete store listing, content rating, pricing, and privacy policy link.

## iOS (App Store)
1. Enroll in Apple Developer Program.
2. Create App Store Connect app with matching Bundle ID.
3. Configure certificates & provisioning profiles (recommended: use Xcode automatic signing).
4. On macOS, build and archive via Xcode or use fastlane:
   ```bash
   bundle exec fastlane ios beta
   ```
5. Upload to TestFlight, test, then submit for review.

## General
- Prepare app screenshots (phone sizes), app icon, feature graphic (Play), and privacy policy URL.
- Have support email and website ready.
- Add Sentry / Crashlytics if you want crash reports.
