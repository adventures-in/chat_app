import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String username;

  ChatPage({Key key, @required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
      ),
      body: Center(),
    );
  }
}
