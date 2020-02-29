import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  static const routeName = '/chat';
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  DocumentReference ref;

  @override
  void initState() {
    super.initState();

    final ChatPageArgs args = ModalRoute.of(context).settings.arguments;
    Firestore.instance
        .collection('conversations')
        .document(args.conversationId)
        .get()
        .then((snapshot) {
      if (snapshot == null) {
        Firestore.instance.collection('conversations').add({
          'participant1': args.currentUserId,
          'particpiant2': args.tappedUserId
        }).then((reference) {
          ref = reference;
        });
      } else {
        ref = snapshot.reference;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ChatPageArgs args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.tappedUsername),
      ),
      body: Center(),
    );
  }
}

class ChatPageArgs {
  final String tappedUsername;
  final String currentUserId;
  final String tappedUserId;
  final String conversationId;

  ChatPageArgs(
      {@required this.tappedUsername,
      @required this.currentUserId,
      @required this.tappedUserId,
      @required this.conversationId});
}
