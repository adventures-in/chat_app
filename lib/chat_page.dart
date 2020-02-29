import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  ChatPage({
    @required this.conversationId,
    @required this.currentUserId,
    @required this.tappedUserId,
    @required this.tappedUsername,
  });
  static const routeName = '/chat';
  final String tappedUsername;
  final String currentUserId;
  final String tappedUserId;
  final String conversationId;
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  DocumentReference ref;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tappedUsername),
      ),
      body: FutureBuilder(
        future: (widget.conversationId == null)
            ? Firestore.instance.collection('conversations').add({
                'participant1': widget.currentUserId,
                'participant2': widget.tappedUserId
              })
            : Firestore.instance
                .collection('conversations')
                .document(widget.conversationId)
                .get(),
        builder: (context, value) {
          if (!value.hasData) {
            return Container();
          }

          DocumentReference ref = (value.data.runtimeType == DocumentSnapshot)
              ? (value.data as DocumentSnapshot).reference
              : value.data;

          return StreamBuilder(
            stream: ref.collection('messages').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              QuerySnapshot querySnapshot = snapshot.data;
              return ListView.builder(
                  itemCount: querySnapshot.documents.length,
                  itemBuilder: (context, index) {
                    final doc = querySnapshot.documents[index];
                    return ListTile(
                      title: Text(doc.data['text']),
                    );
                  });
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: BottomChatBar(
          conversationId: widget.conversationId,
          currentUserId: widget.currentUserId,
        ),
      ),
    );
  }
}

class BottomChatBar extends StatefulWidget {
  final String conversationId;
  final String currentUserId;

  const BottomChatBar({
    @required this.conversationId,
    @required this.currentUserId,
    Key key,
  }) : super(key: key);

  @override
  _BottomChatBarState createState() => _BottomChatBarState();
}

class _BottomChatBarState extends State<BottomChatBar> {
  TextEditingController _controller;

  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Message',
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: () {
            Firestore.instance
                .collection('conversations')
                .document(widget.conversationId)
                .collection('messages')
                .add({
              'authorId': widget.currentUserId,
              'text': _controller.text,
              'timestamp': FieldValue.serverTimestamp()
            });
          },
        ),
      ],
    );
  }
}

class ChatPageArgs {
  final String tappedUsername;
  final String tappedUserId;
  final String conversationId;
  final String currentUserId;

  ChatPageArgs(
      {@required this.tappedUsername,
      @required this.tappedUserId,
      @required this.conversationId,
      @required this.currentUserId});
}
