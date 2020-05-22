import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GoogleSignInButton(
            onPressed: () async {
              _googleSignin(context).listen((event) {
                print(event);
              });
            },
          ),
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
  // signal to change UI
  yield 0;

  try {
    final result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:
        // signal to change UI
        yield 0;

        // retrieve the apple credential and convert to oauth credential
        final appleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider(providerId: 'apple.com');
        final credential = oAuthProvider.getCredential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );

        // use the credential to sign in to firebase
        await FirebaseAuth.instance.signInWithCredential(credential);
        break;
      case AuthorizationStatus.error:
        throw result.error;
        break;

      case AuthorizationStatus.cancelled:
        yield 0;
        break;
    }
  } catch (error, trace) {
    // reset the UI and display an alert

    yield 0;
    // any specific errors are caught and dealt with so we can assume
    // anything caught here is a problem and send to the store for display
    yield AddProblem(
      (b) => b.problem
        ..message = error.toString()
        ..trace = trace.toString()
        ..type = ProblemTypeEnum.appleSignin,
    );
  }
}

Stream<int> _facebookSignin(BuildContext context) async* {
  try {
    final _fireAuth = FirebaseAuth.instance;
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:

        /// the auth info will be picked up by the listener on [onAuthStateChanged]
        /// and emitted by [streamOfStateChanges]

        // signal to change UI
        yield 2;

        final credential = FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token);
        await _fireAuth.signInWithCredential(credential);

        // we are signed in so reset the UI
        yield 0;
        break;
      case FacebookLoginStatus.cancelledByUser:
        // _showCancelledMessage();
        yield 0;
        break;
      case FacebookLoginStatus.error:
        // _showErrorOnUI(result.errorMessage);
        yield 0;
        throw result.errorMessage;
        break;
    }
  } catch (error) {
    // reset the UI and display an alert

    yield 0;
    // errors with code kSignInCanceledError are swallowed by the
    // GoogleSignIn.signIn() method so we can assume anything caught here
    // is unexpected and for display
    _showDialog(context, error.toString());
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
