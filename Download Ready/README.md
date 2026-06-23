# Download Ready

This folder contains the latest release builds of the MBS Currency App.

## Files

| File | Platform | Description |
|------|----------|-------------|
| `app-release.apk` | Android | Signed release APK (debug key) |
| `mbs-currency-app.ipa` | iOS | Unsigned IPA (no codesign) |

## How these are generated

The CI workflow (`.github/workflows/build-and-publish.yml`) automatically builds
both artifacts on every push to `main` and commits the results here.

You can also trigger a build manually via the **Actions** tab → **Build & Publish
Release Artifacts** → **Run workflow**.

## Notes

- The Android APK is signed with the debug keystore and can be side-loaded on any device.
- The iOS IPA is unsigned. To install on a device you need to re-sign it with a
  valid provisioning profile using Xcode or a third-party tool.
