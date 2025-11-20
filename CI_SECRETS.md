# GitHub Actions Secrets for Release CI

Set the following repository secrets (Settings → Secrets & variables → Actions):

- ANDROID_KEYSTORE_BASE64: Base64-encoded Android keystore file content. Example:
  ```bash
  base64 pocketflow-keystore.jks | pbcopy
  ```
- ANDROID_KEYSTORE_PASSWORD: Your keystore password
- ANDROID_KEY_ALIAS: Your key alias (e.g. pocketflow-key)
- ANDROID_KEY_PASSWORD: Your key password

Optional for iOS (if you plan to codesign in CI):
- APPLE_CERT_BASE64: Base64-encoded p12 certificate
- APPLE_CERT_PASSWORD: password for the p12
- FASTLANE_SESSION: (if using fastlane match or automation)

Notes:
- Do NOT store raw keystore files in the repo. Use GitHub Secrets.
- The provided workflow will decode ANDROID_KEYSTORE_BASE64 at build time and create `android/key.properties` used by Gradle for signing.
