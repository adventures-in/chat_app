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
      body: StreamBuilder<UserItem>(
          stream: db.getCurrentUserStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ErrorUI(
                title: 'Something went wrong',
                message: snapshot.error.toString(),
              );
            } else if (snapshot.hasData) {
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
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

class ErrorUI extends StatelessWidget {
  final String title;
  final String message;

  const ErrorUI({
    Key key,
    @required this.message,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          Icons.error_outline,
          size: 100,
          color: theme.errorColor,
        ),
        SizedBox(height: 16),
        Text(
          title,
          style: theme.textTheme.headline5,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Text(
          message,
          style: theme.textTheme.bodyText1,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
