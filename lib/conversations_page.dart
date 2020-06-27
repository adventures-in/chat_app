import 'dart:async';

import 'package:adventures_in_chat_app/chat_page.dart';
import 'package:adventures_in_chat_app/extensions/extensions.dart';
import 'package:adventures_in_chat_app/models/conversation_item.dart';
import 'package:adventures_in_chat_app/models/user_item.dart';
import 'package:adventures_in_chat_app/user_search_page.dart';
import 'package:adventures_in_chat_app/widgets/shared/confirmation_alert.dart';
import 'package:adventures_in_chat_app/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

class ConversationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: StreamBuilder<UserItem>(
            stream: context.db.getCurrentUserStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                );
              } else {
                return UserAvatar(url: snapshot.data.photoURL);
              }
            }),
        title: Text('Conversations'),
        actions: <Widget>[],
      ),
      body: ConversationList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final item = await Navigator.push<ConversationItem>(
            context,
            MaterialPageRoute(
              builder: (context) => UserSearchPage(),
            ),
          );
          // TODO: add item to global state
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class ConversationList extends StatefulWidget {
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: StreamBuilder<List<ConversationItem>>(
            stream: context.db.getConversationsStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data[index];
                  return ConversationsListTile(item: item);
                },
              );
            }),
      ),
    );
  }
}

class ConversationsListTile extends StatelessWidget {
  const ConversationsListTile({
    Key key,
    @required this.item,
  }) : super(key: key);

  final ConversationItem item;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      // Show a red background as the item is swiped away.
      background: Container(color: Colors.red),
      key: Key(item.conversationId),
      onDismissed: (direction) async {
        final confirmed = await _displayConfirmation(context);
        if (confirmed) {
          // TODO: remove item from global state
          await context.db.leaveConversation(item.conversationId);
        }
      },
      child: ListTile(
        leading: UserAvatar(url: item.photoURLs.first),
        title: Text(item.truncatedNames(15)),
        subtitle: Text('Coming soon.'),
        onTap: () {
          Navigator.pushNamed(context, ChatPage.routeName,
              arguments: ChatPageArgs(
                  currentUserId: context.db.currentUserId,
                  conversationItem: item));
        },
      ),
    );
  }

  Future<bool> _displayConfirmation(BuildContext context) async {
    final completer = Completer<bool>();
    final response = await showDialog<bool>(
        context: context,
        builder: (context) {
          return ConfirmationAlert(
              question: 'Do you want to leave the conversation?');
        });
    completer.complete(response);
    return completer.future;
  }
}
