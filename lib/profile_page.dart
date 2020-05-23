import 'package:adventures_in_chat_app/models/user_item.dart';
import 'package:adventures_in_chat_app/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  static final routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<DatabaseService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<UserItem>(
          future: db.getCurrentUserItem(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Material(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(snapshot.data.photoURL)),
                      title: Text(snapshot.data.displayName),
                      onTap: () {
                        debugPrint('Not yet implemented');
                      },
                    ),
                  ],
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
