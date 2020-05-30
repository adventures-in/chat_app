import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  UserAvatar({@required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final checkedURL = url ??
        'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y';
    return CircleAvatar(
      backgroundImage: NetworkImage(checkedURL),
    );
  }
}
