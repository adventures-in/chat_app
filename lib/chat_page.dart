import 'package:adventures_in_chat_app/models/message.dart';
import 'package:adventures_in_chat_app/services/database_service.dart';
import 'package:adventures_in_chat_app/widgets/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:adventures_in_chat_app/models/conversation_item.dart';

class ChatPage extends StatefulWidget {
  ChatPage({
    @required this.conversationItem,
    @required this.currentUserId,
    @required this.db,
  });

  static const routeName = '/chat';
  final ConversationItem conversationItem;
  final String currentUserId;
  final DatabaseService db;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversationItem.conversationId),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: widget.db
                  .getMessagesStream(widget.conversationItem.conversationId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }

                final messages = snapshot.data;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) => ChatMessage(
                    text: messages[index].text,
                    dateTime: messages[index].timestamp,
                  ),
                );
              },
            ),
          ),
          BottomAppBar(
            child: BottomChatBar(
              onSubmit: (String text) {
                widget.db.sendMessage(
                  text: text,
                  userId: widget.currentUserId,
                  conversationId: widget.conversationItem.conversationId,
                );
              },
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}

class BottomChatBar extends StatefulWidget {
  final Function(String) onSubmit;

  const BottomChatBar({
    @required this.onSubmit,
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
    widget.onSubmit(_controller.text);
    _controller.clear();
  }
}

class ChatPageArgs {
  final ConversationItem conversationItem;
  final String currentUserId;

  ChatPageArgs({
    @required this.conversationItem,
    @required this.currentUserId,
  });
}
