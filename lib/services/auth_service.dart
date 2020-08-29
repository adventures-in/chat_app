import 'dart:async';

import 'package:adventures_in_chat_app/enums/auth_step.dart';
import 'package:adventures_in_chat_app/managers/navigation_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final StreamController<AuthStep> _controller;
  final NavigationManager _navManager;

  AuthService(this._firebaseAuth, this._controller, this._navManager);

  Stream<AuthStep> get authStepStream => _controller.stream;

  void signInWithGoogle() async {
    try {
      // emit the inital step
      _controller.add(AuthStep.SIGNING_IN_WITH_GOOGLE);

      // attempt google sign in
      final _googleSignIn = GoogleSignIn(scopes: <String>['email']);
      final _googleUser = await _googleSignIn.signIn();

      // if the user canceled signin, an error is thrown but it gets swallowed
      // by the signIn() method so we need to reset the UI and close the stream
      if (_googleUser == null) {
        _controller.add(AuthStep.WAITING_FOR_INPUT);
        return;
      }

      // signal to change UI
      _controller.add(AuthStep.SIGNING_IN_WITH_FIREBASE);

      // get a credential for the firebase sign in
      final googleAuth = await _googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      /// the auth info will be picked up by the listener on [FirebaseAuth.authStateChanges()]
      await _firebaseAuth.signInWithCredential(credential);

      // we are signed in so reset the UI
      _controller.add(AuthStep.WAITING_FOR_INPUT);
    } catch (error) {
      // reset the UI and display an alert
      _controller.add(AuthStep.WAITING_FOR_INPUT);

      // errors with code kSignInCanceledError are swallowed by the
      // GoogleSignIn.signIn() method so we can assume anything caught here
      // is unexpected and for display
      await _navManager.display(error, StackTrace.current);
    }
  }

  void signinWithApple() async {
    try {
      // emit the inital step
      _controller.add(AuthStep.SIGNING_IN_WITH_GOOGLE);

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
      _controller.add(AuthStep.SIGNING_IN_WITH_FIREBASE);

      // get an OAuthCredential
      final credential = OAuthProvider('apple.com').credential(
        idToken: appleIdCredential.identityToken,
        accessToken: appleIdCredential.authorizationCode,
      );

      // use the credential to sign in to firebase
      await FirebaseAuth.instance.signInWithCredential(credential);

      // we are signed in so reset the UI
      _controller.add(AuthStep.WAITING_FOR_INPUT);
    } on SignInWithAppleAuthorizationException catch (e) {
      // reset the UI and display an alert (unless user canceled sign in)
      _controller.add(AuthStep.WAITING_FOR_INPUT);

      switch (e.code) {
        case AuthorizationErrorCode.canceled:
          break;
        default:
          await _navManager.display(e, StackTrace.current);
      }
    } catch (error, trace) {
      // reset the UI and display an alert

      _controller.add(AuthStep.WAITING_FOR_INPUT);
      // any specific errors are caught and dealt with so we can assume
      // anything caught here is a problem
      await _navManager.display(error, trace);
    }
  }
}
