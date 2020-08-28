# adventures_in_chat_app

A Chat App for Adventures in Flutter.

![CI](https://github.com/adventuresin/chat_app/workflows/Mobile%20Apps/badge.svg)
[![Coverage Status](https://coveralls.io/repos/github/Adventures-In/chat_app/badge.svg)](https://coveralls.io/github/Adventures-In/chat_app)

## Quickstart Guide for Adventures In members 

1. If you haven't been added yet, ask an admin to add you to: 
   - the [Adventures In GitHub organisation](https://github.com/Adventures-In) and the [Chat App team](https://github.com/orgs/Adventures-In/teams/chat-app) 
   - the [Adventures In Asana workspace](https://app.asana.com/0/home/1186146549087468), and specifically the [Chat - Setup project](https://app.asana.com/0/1190914295930489/list) 
   - the [adventures-in-chat](https://console.firebase.google.com/u/0/project/adventures-in-chat/overview) Firebase project 
2. If you're on Android & will use Google Sign In
   - [Add your SHA fingerprint to the Firebase project](https://support.google.com/firebase/answer/9137403?hl=en)
3. If you haven't previously, [install gsutil](https://cloud.google.com/storage/docs/gsutil_install) 
   - make sure you are logged in to gsutil with the same google account that was added to the Firebase project in step 1 
4. Download the required firebase config files by running (from the project directory):
```sh
./scripts/get-config.sh
```
5. If you want to target the web or desktop, follow the setup steps below 
6. Review the [Contributing](https://github.com/Adventures-In/chat_app/wiki/Contributing) wiki page for information on how to proceed.

## Setup for other platforms 

### Channel 

As of now (Aug 2020) you'll need to change to `beta` channel for web and `dev` channel for macOS (`dev` channel will work for both): 
```sh
flutter channel dev
flutter upgrade
```

### Web   

```sh
flutter config --enable-web
```

See: https://flutter.dev/web

### macOS Setup 

```sh
flutter config --enable-macos-desktop
```

See: https://flutter.dev/desktop

## Using another Firebase project 

See wiki page: [Use a different Firebase project (WIP)](https://github.com/Adventures-In/chat_app/wiki/Use-a-different-Firebase-project-(WIP))

