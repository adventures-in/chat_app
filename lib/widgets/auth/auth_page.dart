import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (!Platform.isMacOS)
            GoogleSignInButton(
              onPressed: () async {
                _googleSignin(context).listen((event) {
                  print(event);
                });
              },
            ),
          if (!kIsWeb)
            AppleSignInButton(
                style: AppleButtonStyle.black,
                onPressed: () async {
                  _appleSignin(context).listen((event) {
                    print(event);
                  });
                }),
        ],
      ),
    );
  }
}

Stream<int> _googleSignin(BuildContext context) async* {
  try {
    final _fireAuth = FirebaseAuth.instance;
    final _googleSignIn = GoogleSignIn(scopes: <String>['email']);
    final _googleUser = await _googleSignIn.signIn();

    // if the user canceled signin, an error is thrown but it gets swallowed
    // by the signIn() method so we need to reset the UI and close the stream
    if (_googleUser == null) {
      yield 0;
      return;
    }

    // signal to change UI
    yield 2;

    final googleAuth = await _googleUser.authentication;

    final credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    /// the auth info will be picked up by the listener on [onAuthStateChanged]
    /// and emitted by [streamOfStateChanges]
    await _fireAuth.signInWithCredential(credential);

    // we are signed in so reset the UI
    yield 0;
  } catch (error) {
    // reset the UI and display an alert

    yield 0;
    // errors with code kSignInCanceledError are swallowed by the
    // GoogleSignIn.signIn() method so we can assume anything caught here
    // is unexpected and for display
    _showDialog(context, error.toString());
  }
}

Stream<int> _appleSignin(BuildContext context) async* {
  try {
    // AuthorizationCredentialAppleID
    final appleIdCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: 'adventures-in-chat-service-id',
        redirectUri: Uri.parse(
          'https://safe-chatter-mollusk.glitch.me/callbacks/sign_in_with_apple',
        ),
      ),
    );

    // signal to change UI
    yield 2;

    // get an OAuthCredential
    final credential = OAuthProvider(providerId: 'apple.com').getCredential(
      idToken: appleIdCredential.identityToken,
      accessToken: appleIdCredential.authorizationCode,
    );

    // use the credential to sign in to firebase
    await FirebaseAuth.instance.signInWithCredential(credential);

    // we are signed in so reset the UI
    yield 0;
  } on SignInWithAppleAuthorizationException catch (e) {
    // reset the UI and display an alert (unless user canceled sign in)
    yield 0;

    switch (e.code) {
      case AuthorizationErrorCode.canceled:
        break;
      default:
        _showDialog(context, e.toString());
    }
  } catch (error, trace) {
    // reset the UI and display an alert

    yield 0;
    // any specific errors are caught and dealt with so we can assume
    // anything caught here is a problem
    _showDialog(context, 'error: $error, trace: $trace');
  }
}

void _showDialog(BuildContext context, String errorMessage) {
  // flutter defined function
  showDialog<dynamic>(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: Text('Alert Dialog title'),
        content: Text(errorMessage),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          FlatButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
