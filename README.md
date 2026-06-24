# MBS Currency App

A production-ready Flutter mobile app for the Missouri Boys/Girls State (MBS/MGS)
digital currency platform.  Supports **iOS 14+** and **Android 5.0+ (API 21+)**.


##AI was used for compilation and testing of code, as all of the code was created on a mobile phone, this interation has been sold as a business asset, further development will not be done by me, and realistically the man after me will probably be using AI for most if not all of the programming 

---

## Features

| Feature | Details |
|---|---|
| Parties | Federalist (red gradient card) · Nationalist (blue gradient card) |
| Accounts | Citizen, Corporate, Administrator (`000000`) |
| Transfers | P2P by ID, NFC Tap-to-Pay, Corporate mode |
| Corporate fee | 5 % of principal — atomically routed to admin on every corporate outgoing transfer |
| Messaging | Text chat between citizens, lookup by ID or name |
| Admin dashboard | Manual balance adjustment, full ledger view, fee-accumulation tracking |

---

## Default credentials (seed data)

| Role | ID | Password |
|---|---|---|
| Citizen 1 (Federalist) | `100001` | `password123` |
| Citizen 2 (Nationalist) | `100002` | `password123` |
| Citizen 3 (incomplete profile) | `100003` | `password123` |

Corporate accounts: `C-NEWS` (owner 100001) · `C-CAFE` (owner 100002)

---

## First-time setup

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.24
- For iOS: Xcode 15+, CocoaPods (`gem install cocoapods`)
- For Android: Android Studio with SDK 34

```bash
# 1. Install Dart/Flutter dependencies and generate platform glue code
flutter pub get

# 2. iOS only – install CocoaPods pods (run from the ios/ directory)
cd ios && pod install && cd ..
```

### Run

```bash
# Android (connected device or emulator)
flutter run

# iOS (macOS + Xcode required)
flutter run -d <device-id>
```

### Build release artefacts

```bash
# Android AAB (Play Store)
flutter build appbundle --release

# iOS IPA (requires Apple Developer account + provisioning profile)
flutter build ios --release
```

---

## iOS NFC notes

NFC tag reading on iOS requires:

1. A paid **Apple Developer Program** membership.
2. The `Near Field Communication Tag Reading` capability enabled for your App ID
   in the [Apple Developer portal](https://developer.apple.com).
3. A provisioning profile that includes the NFC entitlement.

The entitlement is already declared in `ios/Runner/Runner.entitlements`.  
On non-NFC devices or simulator, the NFC screen falls back to manual ID entry.

---

## Project structure

```
lib/
  main.dart                  App entry point + root router
  models/                    CitizenAccount, CorporateAccount, AdminAccount,
                             AppTransaction, ChatMessage, enums
  providers/app_state.dart   ChangeNotifier (auth, transfers, chat)
  screens/                   Login, ProfileCompletion, CitizenDashboard,
                             AdminDashboard, Transfer, NfcPayment,
                             Messaging, TransactionHistory
  services/                  LocalDatabaseService (in-memory seed data)
  theme/                     AppTheme (dark #121212 / #1E1E1E)
  widgets/                   BalanceCard (party-tinted gradient)
android/                     Android Gradle project
ios/                         Xcode project (open Runner.xcworkspace)
test/                        Unit tests for fee routing logic
```

---

## Generating app icons

Replace the placeholder 1 × 1 icons with real assets:

```bash
# Add flutter_launcher_icons to dev_dependencies, configure pubspec.yaml, then:
flutter pub run flutter_launcher_icons
```
