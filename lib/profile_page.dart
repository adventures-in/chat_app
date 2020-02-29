import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ProfilePage extends StatelessWidget {
  static final routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(),
      iosContentPadding: true,
      body: FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: PlatformCircularProgressIndicator(),
              );
            } else {
              FirebaseUser user = snapshot.data;
              return Material(
                child: ListTile(
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl)),
                  title: Text(user.displayName),
                  onTap: () {
                    debugPrint("Not yet implemented");
                  },
                ),
              );
            }
          }),
    );
  }
}

void _showDialog(BuildContext context, String errorMessage) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: Text("There was a problem"),
        content: Text(errorMessage),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
