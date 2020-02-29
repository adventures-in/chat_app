import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ChatPageArgs {
  final String username;

  ChatPageArgs(this.username);
}

class ChatPage extends StatelessWidget {
  static const routeName = '/chat';

  @override
  Widget build(BuildContext context) {
    final ChatPageArgs args = ModalRoute.of(context).settings.arguments;

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(args.username),
      ),
      body: Center(),
    );
  }
}
