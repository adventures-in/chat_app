# meetup_chatapp

A Chat App for Adventures in Flutter.

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

## Firebase Backend

To make changes you need to: 
- be an Editor on the Firebase project (just ask someone to be added)
- have installed and setup the [firebase cli](https://firebase.google.com/docs/cli)

### Firestore 

#### Security Rules 

After making changes to `firestore.rules`

```
firebase deploy --only firestore:rules
```

see [Manage and deploy Firebase Security Rules](https://firebase.google.com/docs/rules/manage-deploy)

#### Indexes

After making changes to `firestore.indexes.json`
```
firebase deploy --only firestore:indexes
```

see [Managing indexes  |  Firestore  |  Google Cloud](https://cloud.google.com/firestore/docs/query-data/indexing)

### Cloud Functions 

We are using Cloud Functions for Firebase to automatically run backend code in response to events triggered by Firebase features, such as: 
- Initial Sign In
- Changes to Firestore that should send an FCM

The relevant code is all in `functions/`

After making changes to `functions/index.js`

```
firebase deploy --only functions
```

**Please push up changes to cloud functions in a PR for review before deploying.** 

## Misc Tips

### ios

#### clean script

Useful when expereinceing weirness with Run / Debug

``` sh
cd ios/; rm -rf ~/Library/Caches/CocoaPods Pods ~/Library/Developer/Xcode/DerivedData/*; pod deintegrate; pod setup; pod install;
```
