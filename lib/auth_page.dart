import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GoogleSignInButton(
            onPressed: () async {
              _signin(context).listen((event) {
                print(event);
              });
            },
          ),
          FacebookSignInButton(
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

Stream<int> _signin(BuildContext context) async* {
  try {
    final _fireAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>['email']);
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
  } catch (error, trace) {
    // reset the UI and display an alert

    yield 0;
    // errors with code kSignInCanceledError are swallowed by the
    // GoogleSignIn.signIn() method so we can assume anything caught here
    // is unexpected and for display
    _showDialog(context);
  }
}

void _showDialog(BuildContext context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Alert Dialog title"),
        content: new Text("Alert Dialog body"),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
