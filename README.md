# adventures_in_chat_app

A Chat App for Adventures in Flutter.

![CI](https://github.com/adventuresin/chat_app/workflows/Mobile%20Apps/badge.svg)
[![Coverage Status](https://coveralls.io/repos/github/Adventures-In/chat_app/badge.svg)](https://coveralls.io/github/Adventures-In/chat_app)

## Quickstart Guide 

1. Join the [adventures-in Firebase project](https://console.firebase.google.com/u/0/project/adventures-in/overview) -> send your google account email to an admin, eg. nick.meinhold@gmail.com
2. [Install gsutil](https://cloud.google.com/storage/docs/gsutil_install) and login with the same google account you used in the previous step
3. Download the required credential files -> from the project directory, run `./get-credentials.sh`

- If you're on Android & will use Google Sign In
  - [Add a SHA fingerprint to the Firebase project](https://support.google.com/firebase/answer/9137403?hl=en)

## Local Emulators 

The [Firebase Local Emulator Suite](https://firebase.google.com/docs/emulator-suite) lets the app to connect to a local, emulated version of the Firestore and Cloud Functions, so that you can prototype and test without affecting the live Firestore, and restart from the default data at any time.

With the [Firebase CLI](https://firebase.google.com/docs/cli?hl=pl) installed, start the emulators with: 

```sh
firebase emulators:start --import=test/data
```

The app needs to be run with the alternative entry point `lib/main_local.dart` 
- already set as a VSCode launch option 
- if someone could add a note on how to do this with AS that would be awesome 

If you want your changes become the new default, in another terminal enter:

```sh
firebase emulators:export ./test/data
```

Notes: 
- Any service that is not emulated (eg. Auth, Storage) uses the live version 

### iOS Signing

We are using [match](https://docs.fastlane.tools/actions/match/) to manage Provisioning Profiles and Certificates.

IF you have not already, install fastlane:

```sh
gem install fastlane
```

Install the required Provisioning Profiles and Certificates by entering:

```sh
cd ios
fastlane match development
```

## Firebase Backend

Install the [firebase cli](https://firebase.google.com/docs/cli) if you want to make changes to Firestore Security Rules or Cloud Functions. 

### Firestore

#### Security Rules

After making changes to `firestore.rules` you can deploy with

```sh
firebase deploy --only firestore:rules
```

see [Manage and deploy Firebase Security Rules](https://firebase.google.com/docs/rules/manage-deploy)

#### Indexes

After making changes to `firestore.indexes.json` yo can deploy with

```sh
firebase deploy --only firestore:indexes
```

see [Managing indexes  |  Firestore  |  Google Cloud](https://cloud.google.com/firestore/docs/query-data/indexing)

### Cloud Functions

We are using Cloud Functions for Firebase to automatically run backend code in response to events triggered by Firebase Auth, Firestore, Cloud Storage.

The relevant code is in `functions/`

After making changes to `functions/src/index.ts` you can deploy with

```sh
firebase deploy --only functions
```

**Please push up changes to cloud functions in a PR for review before deploying.**

## macOS 

### Setup 

Run 
```sh
flutter config --enable-macos-desktop
```

See: https://flutter.dev/desktop

## Web

### Build

```sh
flutter build web -t lib/main_web.dart 
```

- builds to `build/web/`

### Deploy

```sh
firebase deploy --only hosting:adventures-in
```

## Testing 

```sh
flutter test
```
