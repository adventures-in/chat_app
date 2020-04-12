import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum UIStatus {
  loading,
  done,
  error,
}

class LinkAccountsPage extends StatelessWidget {
  static final routeName = '/link_accounts';
  final StreamController<UIStatus> _uiController = StreamController();

  Future<void> _linkGoogle(FirebaseUser user) async {
    // signal to change UI
    _uiController.add(UIStatus.loading);

    try {
      final _googleSignIn = GoogleSignIn(scopes: <String>['email']);
      final _googleUser = await _googleSignIn.signIn();

      // if the user canceled signin, an error is thrown but it gets swallowed
      // by the signIn() method so we need to reset the UI and close the stream
      if (_googleUser == null) {
        _uiController.add(UIStatus.done);
        return;
      }

      final googleAuth = await _googleUser.authentication;

      final credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await user.linkWithCredential(credential);

      // we are linked so reload the user's data and reset the UI
      await user.reload();
      _uiController.add(UIStatus.done);
    } catch (error) {
      // reset the UI and display an alert
      _uiController.add(UIStatus.error);
      // errors with code kSignInCanceledError are swallowed by the
      // GoogleSignIn.signIn() method so we can assume anything caught here
      // is unexpected and for display
      rethrow;
    }
  }

  Future<void> _linkFacebook(FirebaseUser user) async {
    // signal to change UI
    _uiController.add(UIStatus.loading);

    try {
      final facebookLogin = FacebookLogin();
      final result = await facebookLogin.logIn(['email']);

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:

          /// the auth info will be picked up by the listener on [onAuthStateChanged]
          /// and emitted by [streamOfStateChanges]

          final credential = FacebookAuthProvider.getCredential(
              accessToken: result.accessToken.token);

          await user.linkWithCredential(credential);

          // we are signed in so reload the user's data and reset the UI
          await user.reload();
          _uiController.add(UIStatus.done);
          break;
        case FacebookLoginStatus.cancelledByUser:
          _uiController.add(UIStatus.done);
          break;
        case FacebookLoginStatus.error:
          _uiController.add(UIStatus.error);
          throw result.errorMessage;
          break;
      }
    } catch (error) {
      // reset the UI and display an alert
      _uiController.add(UIStatus.error);
      rethrow;
    }
  }

  Widget _buildLoadingUI() {
    // TODO improve
    return CircularProgressIndicator();
  }

  Widget _buildErrorUI() {
    // TODO improve
    return Icon(Icons.mood_bad);
  }

  Widget _buildLoadedUI(BuildContext context, FirebaseUser user) {
    var buttons = <Widget>[];

    if (!_hasLinkedProvider('google.com', user.providerData)) {
      buttons.add(GoogleSignInButton(
        onPressed: () {
          _linkGoogle(user)
              .catchError((Object err) => _showDialog(context, err.toString()));
        },
      ));
    }

    if (!_hasLinkedProvider('facebook.com', user.providerData)) {
      buttons.add(FacebookSignInButton(
        onPressed: () {
          _linkFacebook(user)
              .catchError((Object err) => _showDialog(context, err.toString()));
        },
      ));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: buttons.isNotEmpty
          ? [
              Text('Link your accounts'),
              ...buttons,
            ]
          : <Widget>[
              Icon(
                Icons.mood,
                size: 100,
              ),
              Text('You\'re all set!',
                  style: Theme.of(context).textTheme.headline5),
            ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: StreamBuilder<UIStatus>(
              initialData: UIStatus.done,
              stream: _uiController.stream,
              builder: (context, snapshot) {
                switch (snapshot.data) {
                  // Errors are already displayed as alert dialogs
                  case UIStatus.done:
                  case UIStatus.error:
                    return FutureBuilder<FirebaseUser>(
                        future: FirebaseAuth.instance.currentUser(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return _buildLoadedUI(context, snapshot.data);
                          } else {
                            return _buildLoadingUI();
                          }
                        });
                  default:
                    return _buildLoadingUI();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

bool _hasLinkedProvider(String id, List<UserInfo> providersInfo) {
  for (final info in providersInfo) {
    if (info.providerId == id) {
      return true;
    }
  }
  return false;
}

void _showDialog(BuildContext context, String errorMessage) {
  // flutter defined function
  showDialog<dynamic>(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: Text('There was a problem'),
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
