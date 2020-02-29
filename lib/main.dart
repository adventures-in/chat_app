import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meetup_chatapp/auth_page.dart';
import 'package:provider/provider.dart';
import 'package:meetup_chatapp/chat_page.dart';
import 'package:meetup_chatapp/home.dart';
import 'package:meetup_chatapp/splash.dart';
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
      onGenerateRoute: (settings) {
        // If we push the ChatPage route
        if (settings.name == ChatPage.routeName) {
          // Cast the arguments to the correct type: ChatPageArgs.
          final ChatPageArgs args = settings.arguments;

          // Then, extract the required data from the arguments and
          // pass the data to the correct screen.
          return MaterialPageRoute(
            builder: (context) {
              return ChatPage(
                conversationId: args.conversationId,
                tappedUserId: args.tappedUserId,
                tappedUsername: args.tappedUsername,
                currentUserId: args.currentUserId,
              );
            },
          );
        }
        return MaterialPageRoute(builder: (context) {
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
