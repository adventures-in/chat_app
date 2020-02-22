# meetup_chatapp

A Chat App for Adventures in Flutter.

## Missing Files

### Firebase Config

Get `GoogleService-Info.plist` and `google-services.json` from the [Shared Project Folder](https://drive.google.com/drive/folders/1URxuILxk8NR66DIRbuERFDXIILCX6jM2?usp=sharing)

Add them to your project at:

- `ios/Runner/GoogleService-Info.plist`
- `android/app/google-services.json`

## Cloud Functions 

We are using Cloud Functions for Firebase to automatically run backend code in response to events triggered by Firebase features, such as: 
- Initial Sign In
- Changes to Firestore that should send an FCM

The relevant code is all in `functions/`

To deploy: 
```
firebase deploy --only functions
```

## Misc Tips

### ios

#### clean script

Useful when expereinceing weirness with Run / Debug

``` sh
cd ios/; rm -rf ~/Library/Caches/CocoaPods Pods ~/Library/Developer/Xcode/DerivedData/*; pod deintegrate; pod setup; pod install;
```
