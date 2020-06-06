import 'dart:io';

import 'package:adventures_in_chat_app/chat_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];

    print(data);
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];

    print(notification);
  }

  return null;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // set firestore to connect to local emulated firestore
  await Firestore.instance.settings(
    host: 'localhost:8081',
    sslEnabled: false,
    persistenceEnabled: false,
  );

  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print('onMessage: $message');
      // _showItemDialog(message);
    },
    // TODO: remove the check for iOS when the plugin has updated
    onBackgroundMessage: Platform.isIOS ? null : backgroundMessageHandler,
    onLaunch: (Map<String, dynamic> message) async {
      print('onLaunch: $message');
      // _navigateToItemDetail(message);
    },
    onResume: (Map<String, dynamic> message) async {
      print('onResume: $message');
      // _navigateToItemDetail(message);
    },
  );

  _firebaseMessaging.requestNotificationPermissions();

  runApp(ChatApp());
}
