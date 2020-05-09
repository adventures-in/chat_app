import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:adventures_in_chat_app/link_accounts_page.dart';
import 'package:adventures_in_chat_app/profile_page.dart';

class OptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Settings')),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.account_circle, size: 32),
              title: const Text('View Profile'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  ProfilePage.routeName,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.textsms, size: 32),
              title: const Text('Message Requests'),
              onTap: () {
                debugPrint('Not yet implemented');
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app,
                  size: 32, color: Theme.of(context).errorColor),
              title: Text('Logout',
                  style: TextStyle(color: Theme.of(context).errorColor)),
              onTap: () {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: <Widget>[
                          FlatButton(
                              child: const Text('CANCEL'),
                              onPressed: () {
                                Navigator.pop(dialogContext);
                              }),
                          FlatButton(
                            child: Text('LOGOUT',
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
              title: const Text('Link Accounts'),
              onTap: () {
                Navigator.pushNamed(context, LinkAccountsPage.routeName);
              },
            ),
            AboutListTile(
              icon: const Icon(Icons.help_outline, size: 32),
              applicationIcon: Image.asset(
                'assets/images/logo.png',
                height: 64,
              ),
              applicationVersion: '1.0.0+1',
            ),
          ],
        ));
  }
}
