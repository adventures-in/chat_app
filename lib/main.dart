import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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
    final materialTheme = ThemeData(
      primarySwatch: Colors.blue,
    );
    final cupertinoTheme = new CupertinoThemeData(
      brightness: Brightness.light, // if null will use the system theme
      primaryColor: CupertinoDynamicColor.withBrightness(
        color: Colors.blue,
        darkColor: Colors.cyan,
      ),
    );

    return PlatformProvider(
      settings: PlatformSettingsData(iosUsesMaterialWidgets: true),
      // initialPlatform: TargetPlatform.iOS, // Use this to switch between different platform UIs
      builder: (BuildContext context) => PlatformApp(
        title: 'Flutter Demo',
        android: (_) {
          return new MaterialAppData(
            theme: materialTheme,
          );
        },
        ios: (_) => new CupertinoAppData(
          theme: cupertinoTheme,
        ),
        localizationsDelegates: [
          DefaultMaterialLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
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
      ),
    );
  }
}

/*
theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
 */
