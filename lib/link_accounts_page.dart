import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LinkAccountsPage extends StatelessWidget {
  static final routeName = '/link_accounts';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              final user = snapshot.data as FirebaseUser;
              return Material(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (!_hasLinkedProvider('google.com', user.providerData))
                      GoogleSignInButton(
                        onPressed: () async {
                          _linkGoogle(context, user).listen((event) {
                            print(event);
                          });
                        },
                      ),
                    if (!_hasLinkedProvider('facebook.com', user.providerData))
                      FacebookSignInButton(
                        onPressed: () {
                          _linkFacebook(context, user).listen((event) {
                            print(event);
                          });
                        },
                      ),
                  ],
                ),
              );
            }
          }),
    );
  }
}

bool _hasLinkedProvider(String id, List<UserInfo> providersInfo) {
  for (UserInfo info in providersInfo) {
    if (info.providerId == id) {
      return true;
    }
  }
  return false;
}

Stream<int> _linkGoogle(BuildContext context, FirebaseUser user) async* {
  try {
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

    await user.linkWithCredential(credential);

    // we are linked so reset the UI
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

Stream<int> _linkFacebook(BuildContext context, FirebaseUser user) async* {
  try {
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

        await user.linkWithCredential(credential);

        // we are signed in so reset the UI
        yield 0;
        break;
      case FacebookLoginStatus.cancelledByUser:
        yield 0;
        break;
      case FacebookLoginStatus.error:
        yield 0;
        throw result.errorMessage;
        break;
    }
  } catch (error) {
    // reset the UI and display an alert

    yield 0;
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
        title: Text("There was a problem"),
        content: Text(errorMessage),
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
