import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meetup_chatapp/auth_page.dart';
import 'package:provider/provider.dart';
import 'package:meetup_chatapp/chat_page.dart';
import 'package:meetup_chatapp/home_page.dart';
import 'package:meetup_chatapp/splash_page.dart';
import 'package:meetup_chatapp/link_accounts_page.dart';
import 'package:meetup_chatapp/profile_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
        ChatPage.routeName: (context) => ChatPage(),
        ProfilePage.routeName: (context) => ProfilePage(),
        LinkAccountsPage.routeName: (context) => LinkAccountsPage(),
      },
    );
  }
}
