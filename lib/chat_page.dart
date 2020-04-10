import 'package:adventures_in_chat_app/widgets/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:adventures_in_chat_app/models/conversation_item.dart';

class ChatPage extends StatefulWidget {
  ChatPage({
    @required this.conversationItem,
    @required this.currentUserId,
  });

  static const routeName = '/chat';
  final ConversationItem conversationItem;
  final String currentUserId;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  DocumentReference ref;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversationItem.conversationId),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection(
                      'conversations/${widget.conversationItem.conversationId}/messages')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                final querySnapshot = snapshot.data as QuerySnapshot;
                return ListView.builder(
                    itemCount: querySnapshot.documents.length,
                    itemBuilder: (context, index) {
                      final doc = querySnapshot.documents[index];
                      return ChatMessage(text: doc.data['text'] as String);
                    });
              },
            ),
          ),
          BottomAppBar(
            child: BottomChatBar(
              conversationId: widget.conversationItem.conversationId,
              currentUserId: widget.currentUserId,
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
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

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
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
            onSubmitted: (_) => _submitMessage(),
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: () => _submitMessage(),
        ),
      ],
    );
  }

  void _submitMessage() {
    final messageText = _controller.text;
    _controller.clear();
    Firestore.instance
        .collection('conversations')
        .document(widget.conversationId)
        .collection('messages')
        .add(<String, dynamic>{
      'authorId': widget.currentUserId,
      'text': messageText,
      'timestamp': FieldValue.serverTimestamp()
    });
  }
}

class ChatPageArgs {
  final ConversationItem conversationItem;
  final String currentUserId;

  ChatPageArgs({@required this.conversationItem, @required this.currentUserId});
}
