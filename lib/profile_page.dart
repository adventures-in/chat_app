import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  static final routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              final user = snapshot.data as FirebaseUser;
              return Material(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.photoUrl)),
                      title: Text(user.displayName),
                      onTap: () {
                        debugPrint("Not yet implemented");
                      },
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
