import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  UserAvatar({@required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: NetworkImage(url),
    );
  }
}
