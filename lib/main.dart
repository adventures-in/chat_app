import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:adventures_in_chat_app/auth_page.dart';
import 'package:provider/provider.dart';
import 'package:adventures_in_chat_app/chat_page.dart';
import 'package:adventures_in_chat_app/home_page.dart';
import 'package:adventures_in_chat_app/splash_page.dart';
import 'package:adventures_in_chat_app/link_accounts_page.dart';
import 'package:adventures_in_chat_app/profile_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
                child: HomePage(),
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
