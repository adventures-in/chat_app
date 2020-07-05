import 'package:adventures_in_chat_app/models/message.dart';
import 'package:adventures_in_chat_app/services/database_service.dart';
import 'package:adventures_in_chat_app/widgets/messages/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:adventures_in_chat_app/models/conversation_item.dart';
import 'package:adventures_in_chat_app/extensions/extensions.dart';

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
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversationItem.conversationId),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<MessagesListItem>>(
              stream: widget.db
                  .getMessagesStream(widget.conversationItem.conversationId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }

                return MessagesList(
                    controller: _controller, items: snapshot.data);
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

class MessagesList extends StatefulWidget {
  const MessagesList({
    Key key,
    @required ScrollController controller,
    @required this.items,
  })  : controller = controller,
        super(key: key);

  final ScrollController controller;
  final List<MessagesListItem> items;

  @override
  _MessagesListState createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.controller.jumpTo(widget.controller.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        controller: widget.controller,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final item = widget.items[index];

          return (item.runtimeType == Message)
              ? Row(
                  mainAxisAlignment: ((item as Message).authorUserId ==
                          context.db.currentUserId)
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end,
                  children: [
                    ChatMessage(text: item.outputText),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChatMessage(text: item.outputText),
                  ],
                );
        });
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
