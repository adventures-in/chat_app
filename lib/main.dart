import 'dart:io';

import 'package:adventures_in_chat_app/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:adventures_in_chat_app/auth_page.dart';
import 'package:provider/provider.dart';
import 'package:adventures_in_chat_app/chat_page.dart';
import 'package:adventures_in_chat_app/home_page.dart';
import 'package:adventures_in_chat_app/splash_page.dart';
import 'package:adventures_in_chat_app/link_accounts_page.dart';
import 'package:adventures_in_chat_app/profile_page.dart';

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

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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

  _firebaseMessaging.getToken().then(print);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final DatabaseService db = DatabaseService(Firestore.instance);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adventures In',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: (settings) {
        // If we push the ChatPage route
        if (settings.name == ChatPage.routeName) {
          // Cast the arguments to the correct type: ChatPageArgs.
          final args = settings.arguments as ChatPageArgs;

          // Then, extract the required data from the arguments and
          // pass the data to the correct screen.
          return MaterialPageRoute<dynamic>(
            builder: (context) {
              return ChatPage(
                conversationItem: args.conversationItem,
                currentUserId: args.currentUserId,
                db: db,
              );
            },
          );
        }
        return MaterialPageRoute<dynamic>(builder: (context) {
          return Container();
        });
      },
      home: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return Provider<FirebaseUser>.value(
                value: snapshot.data as FirebaseUser,
                child: HomePage(
                  db: db,
                ),
              );
            } else {
              return AuthPage();
            }
          }

          return SplashPage();
        },
      ),
      routes: {
        ProfilePage.routeName: (context) => ProfilePage(),
        LinkAccountsPage.routeName: (context) => LinkAccountsPage(),
      },
    );
  }
}
