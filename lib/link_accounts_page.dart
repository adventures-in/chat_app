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

class LinkAccountsPage extends StatefulWidget {
  static final routeName = '/link_accounts';

  @override
  State<StatefulWidget> createState() => LinkAccountsPageState();
}

class LinkAccountsPageState extends State<LinkAccountsPage> {
  UIStatus _status = UIStatus.loading;
  FirebaseUser _user;

  void _updateUser() async {
    setState(() {
      _status = UIStatus.loading;
      _user = null;
    });

    var user = await FirebaseAuth.instance.currentUser();

    if (user == null) {
      // Show an error if we don't have the current user's data.
      // This shouldn't happen, but it's better to handle the case anyway.
      setState(() {
        _status = UIStatus.error;
        _user = null;
      });
    } else {
      setState(() {
        _status = UIStatus.done;
        _user = user;
      });
    }
  }

  // TODO use different enum for linking status events
  void _handleEvents(UIStatus event) {
    switch (event) {
      case UIStatus.loading:
        setState(() {
          _status = event;
        });
        break;
      default:
        _updateUser();
        break;
    }
  }

  Widget _buildLoadedUI(BuildContext context) {
    var buttons = <Widget>[];

    if (!_hasLinkedProvider('google.com', _user.providerData)) {
      buttons.add(GoogleSignInButton(
        onPressed: () {
          _linkGoogle(_user).listen(
            _handleEvents,
            onError: (Object err) => _showDialog(context, err.toString()),
          );
        },
      ));
    }

    if (!_hasLinkedProvider('facebook.com', _user.providerData)) {
      buttons.add(FacebookSignInButton(
        onPressed: () {
          _linkFacebook(_user).listen(
            _handleEvents,
            onError: (Object err) => _showDialog(context, err.toString()),
          );
        },
      ));
    }

    return Center(
      child: Column(
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
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: (() {
        switch (_status) {
          case UIStatus.done:
            return _buildLoadedUI(context);
          case UIStatus.loading:
            return CircularProgressIndicator();
          default:
            return Icon(Icons.mood_bad); // TODO create error UI
        }
      })(),
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

Stream<UIStatus> _linkGoogle(FirebaseUser user) async* {
  try {
    final _googleSignIn = GoogleSignIn(scopes: <String>['email']);
    final _googleUser = await _googleSignIn.signIn();

    // if the user canceled signin, an error is thrown but it gets swallowed
    // by the signIn() method so we need to reset the UI and close the stream
    if (_googleUser == null) {
      yield UIStatus.done;
      return;
    }

    // signal to change UI
    yield UIStatus.loading;

    final googleAuth = await _googleUser.authentication;

    final credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await user.linkWithCredential(credential);

    // we are linked so reset the UI
    yield UIStatus.done;
  } catch (error) {
    // reset the UI and display an alert

    yield UIStatus.done;
    // errors with code kSignInCanceledError are swallowed by the
    // GoogleSignIn.signIn() method so we can assume anything caught here
    // is unexpected and for display
    rethrow;
  }
}

Stream<UIStatus> _linkFacebook(FirebaseUser user) async* {
  try {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:

        /// the auth info will be picked up by the listener on [onAuthStateChanged]
        /// and emitted by [streamOfStateChanges]

        // signal to change UI
        yield UIStatus.loading;

        final credential = FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token);

        await user.linkWithCredential(credential);

        // we are signed in so reset the UI
        yield UIStatus.done;
        break;
      case FacebookLoginStatus.cancelledByUser:
        yield UIStatus.done;
        break;
      case FacebookLoginStatus.error:
        yield UIStatus.done;
        throw result.errorMessage;
        break;
    }
  } catch (error) {
    // reset the UI and display an alert
    yield UIStatus.done;
    rethrow;
  }
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
