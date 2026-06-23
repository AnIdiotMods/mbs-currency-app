# Pre-built APK and IPA Files

This project uses GitHub Actions to automatically build Android APK and iOS IPA files for easy installation.

## Downloading Pre-built Files

### From GitHub Releases

When a new release is published, pre-built APK and IPA files are automatically attached to the release. Visit the [Releases page](../../releases) to download the latest version.

### From GitHub Actions Artifacts

Every push to `main` and every pull request generates build artifacts:

1. Go to the [Actions tab](../../actions)
2. Click on the latest successful **Build APK and IPA** workflow run
3. Scroll down to the **Artifacts** section
4. Download `app-release-apk` (Android) or `app-release-ipa` (iOS)

## Installing the APK (Android)

1. Download `app-release.apk` to your Android device
2. Open the file — you may need to enable **Install from unknown sources** in your device settings
3. Follow the on-screen prompts to install

## Installing the IPA (iOS)

> **Note:** The IPA is built without code signing. To install on a physical device, you will need to re-sign it or use a service like AltStore/Sideloadly.

1. Download `app-release.ipa`
2. Use one of the following methods to install:
   - **AltStore**: Import the IPA file into AltStore on your device
   - **Sideloadly**: Connect your device to a computer and sideload the IPA
   - **Xcode**: Use the Devices & Simulators window to install the IPA (requires a valid provisioning profile)

## Manual Builds

To build locally:

```bash
# Android APK
flutter build apk --release

# iOS IPA (requires macOS with Xcode)
flutter build ios --release --no-codesign
```
