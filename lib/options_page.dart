import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:meetup_chatapp/link_accounts_page.dart';
import 'package:meetup_chatapp/profile_page.dart';

class OptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        appBar: PlatformAppBar(
          title: Text("Settings"),
          ios: (context) =>
              CupertinoNavigationBarData(transitionBetweenRoutes: false),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.account_circle, size: 32),
              title: const Text("View Profile"),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  ProfilePage.routeName,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.textsms, size: 32),
              title: const Text("Message Requests"),
              onTap: () {
                debugPrint("Not yet implemented");
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app,
                  size: 32, color: Theme.of(context).errorColor),
              title: Text("Logout",
                  style: TextStyle(color: Theme.of(context).errorColor)),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return PlatformAlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: <Widget>[
                          PlatformDialogAction(
                              child: PlatformText("Cancel"),
                              onPressed: () {
                                Navigator.pop(dialogContext);
                              }),
                          PlatformDialogAction(
                            child: PlatformText("Logout",
                                style: TextStyle(
                                    color: Theme.of(context).errorColor)),
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();

                              Navigator.pop(dialogContext);
                            },
                          )
                        ],
                      );
                    });
              },
            ),
            ListTile(
              leading: const Icon(Icons.link, size: 32),
              title: const Text("Link Accounts"),
              onTap: () {
                Navigator.pushNamed(context, LinkAccountsPage.routeName);
              },
            ),
          ],
        ));
  }
}
