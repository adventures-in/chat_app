# adventures_in_chat_app

A Chat App for Adventures in Flutter.

![CI](https://github.com/adventuresin/chat_app/workflows/Mobile%20Apps/badge.svg)

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


## Missing Files

### Firebase Config

Get `GoogleService-Info.plist` and `google-services.json` from the [adventures-in-credentials bucket](https://console.cloud.google.com/storage/browser/adventures-in-credentials?project=adventures-in)

Add them to your project at:

- `ios/Runner/GoogleService-Info.plist`
- `android/app/google-services.json`

*Note:* if you would like to run the app on Android, you will need to have add your SHA-1 debug key to the firebase project:

1. Run `keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore` to find your SHA-1 debug key
1. Just press enter when it asks for a password
1. Open [Firebase](https://console.firebase.google.com) > `adventures-in` > `Project Settings` > `Your Apps` > `Android Chat` > `Add fingerprint`

### iOS Signing

We are using [match](https://docs.fastlane.tools/actions/match/) to manage Provisioning Profiles and Certificates.

You'll need to get `gc_keys.json` from the [adventures-in-credentials](https://console.cloud.google.com/storage/browser/adventures-in-credentials?forceOnBucketsSortingFiltering=false&project=adventures-in) bucket and add it to `ios/gc_keys.json`, then install the required Provisioning Profiles and Certificates by entering:

Install fastlane

```sh
gem install fastlane
```

```sh
cd ios
fastlane match development
```

You will be prompted for `Password (for ci@enspyr.co):` ask Nick or David.

For deploying you may need:

```sh
fastlane match appstore
```

### Android Signing

Get `keystore.config` and `keystore.jks` from the [adventures-in-credentials bucket](https://console.cloud.google.com/storage/browser/adventures-in-credentials?project=adventures-in) and put both files in the `android/app` folder.

## Firebase Backend

To make changes you need to:

- be an Editor on the Firebase project (just ask someone to be added)
- have installed and setup the [firebase cli](https://firebase.google.com/docs/cli)

### Firestore

#### Security Rules

After making changes to `firestore.rules`

```sh
firebase deploy --only firestore:rules
```

see [Manage and deploy Firebase Security Rules](https://firebase.google.com/docs/rules/manage-deploy)

#### Indexes

After making changes to `firestore.indexes.json`

```sh
firebase deploy --only firestore:indexes
```

see [Managing indexes  |  Firestore  |  Google Cloud](https://cloud.google.com/firestore/docs/query-data/indexing)

### Cloud Functions

We are using Cloud Functions for Firebase to automatically run backend code in response to events triggered by Firebase features, such as:

- Initial Sign In
- Changes to Firestore that should send an FCM

The relevant code is all in `functions/`

After making changes to `functions/src/index.ts`

```sh
firebase deploy --only functions
```

**Please push up changes to cloud functions in a PR for review before deploying.**

## Web

### Build

```sh
flutter build web -t lib/main_web.dart 
```

- builds to `build/web/`

### Test

```sh
flutter test
```

### Deploy

```sh
firebase deploy --only hosting:adventures-in
```

## Misc Tips

Restart vs code after `flutter upgrade`.

The following will change versions to the latest and greatest regardless for whats is currently in the lock file.

```sh
pod update
```

You can be on `stable` channel or `dev` based on your appietite.

```sh
flutter channel dev
flutter upgrade
```

Close and Reopen VS Code after a upgrade to avoid issues
