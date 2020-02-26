import 'package:flutter/material.dart';

class ChatPageArgs {
  final String username;

  ChatPageArgs(this.username);
}

class ChatPage extends StatelessWidget {
  static const routeName = '/chat';

  @override
  Widget build(BuildContext context) {
    final ChatPageArgs args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.username),
      ),
      body: Center(),
    );
  }
}
