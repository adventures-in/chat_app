import 'dart:async';

import 'package:adventures_in_chat_app/widgets/dialogs/confirmation_alert.dart';
import 'package:adventures_in_chat_app/widgets/dialogs/error_alert.dart';
import 'package:flutter/material.dart';

class NavigationService {
  final _navKey = GlobalKey<NavigatorState>();
  NavigationService();

  GlobalKey<NavigatorState> get key => _navKey;

  /// Use [NavigatorState.pushNamed] to push a named route onto the navigator.
  Future<void> navigateTo(String location) =>
      _navKey.currentState.pushNamed(location);

  void popHome() {
    /// The [popHome] method calls [NavigatorState.popUntil], passing a
    /// [RoutePredicate] created with [ModalRoute.withName]('/')
    ///
    /// The [RoutePredicate] is used to pop until the condition is met
    _navKey.currentState.popUntil(ModalRoute.withName('/'));
  }

  void replaceCurrentWith(String newRouteName) =>
      _navKey.currentState.pushReplacementNamed(newRouteName);

  Future<void> display(dynamic error, StackTrace trace) => showDialog<dynamic>(
      context: _navKey.currentState.overlay.context,
      builder: (context) => ErrorAlert(
          errorMessage: error.toString(), traceString: trace.toString()));

  Future<bool> confirm(String question) => showDialog<bool>(
      context: _navKey.currentState.overlay.context,
      builder: (context) => ConfirmationAlert(question: question));
}
