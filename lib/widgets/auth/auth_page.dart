import 'dart:io';

import 'package:adventures_in_chat_app/enums/auth_step.dart';
import 'package:adventures_in_chat_app/managers/navigation_manager.dart';
import 'package:adventures_in_chat_app/services/auth_service.dart';
import 'package:adventures_in_chat_app/widgets/shared/waiting_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: StreamBuilder<AuthStep>(
            stream: context.read<AuthService>().authStepStream,
            builder: (context, snapshot) {
              // display an error if found
              if (context.read<NavigationManager>().hasError(snapshot)) {
                return AuthButtons();
              }

              // return the relevant widget
              switch (snapshot.data) {
                case AuthStep.WAITING_FOR_INPUT:
                  return AuthButtons();
                case AuthStep.SIGNING_IN_WITH_APPLE:
                  return WaitingIndicator('Signing In With Apple');
                case AuthStep.SIGNING_IN_WITH_GOOGLE:
                  return WaitingIndicator('Signing In With Google');
                case AuthStep.SIGNING_IN_WITH_FIREBASE:
                  return WaitingIndicator('Signing In With Firebase');
              }
              return AuthButtons();
            }));
  }
}

class AuthButtons extends StatelessWidget {
  const AuthButtons({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (kIsWeb || !Platform.isMacOS)
          GoogleSignInButton(
            onPressed: () => context.read<AuthService>().signInWithGoogle(),
          ),
        if (!kIsWeb)
          AppleSignInButton(
            style: AppleButtonStyle.black,
            onPressed: () => context.read<AuthService>().signinWithApple(),
          ),
      ],
    );
  }
}
