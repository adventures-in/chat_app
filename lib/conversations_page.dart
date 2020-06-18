import 'dart:async';

import 'package:adventures_in_chat_app/chat_page.dart';
import 'package:adventures_in_chat_app/extensions/extensions.dart';
import 'package:adventures_in_chat_app/models/conversation_item.dart';
import 'package:adventures_in_chat_app/models/user_item.dart';
import 'package:adventures_in_chat_app/user_search_page.dart';
import 'package:adventures_in_chat_app/widgets/shared/confirmation_alert.dart';
import 'package:adventures_in_chat_app/widgets/user_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConversationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final db = context.db;
    return Scaffold(
      appBar: AppBar(
        leading: StreamBuilder<UserItem>(
            stream: db.getCurrentUserStream(),
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
          final conversationItem = await Navigator.push<ConversationItem>(
            context,
            MaterialPageRoute(
              builder: (context) => UserSearchPage(),
            ),
          );
          if (conversationItem != null) {
            Provider.of<ConversationsViewModel>(context, listen: false)
                .add(item: conversationItem);
          }
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
    final currentUserId = context.db.currentUserId;
    return Container(
      child: Center(
        child: StreamBuilder(
            stream: Firestore.instance
                .collection('conversations')
                .where('uids', arrayContains: currentUserId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              final querySnapshot = snapshot.data as QuerySnapshot;
              Provider.of<ConversationsViewModel>(context).populateWith(
                querySnapshot.documents
                    .map(
                      (itemDoc) => ConversationItem(
                          conversationId: itemDoc.documentID,
                          uids: List.from(itemDoc.data['uids'] as List),
                          displayNames:
                              List.from(itemDoc.data['displayNames'] as List),
                          photoURLs:
                              List.from(itemDoc.data['photoURLs'] as List)),
                    )
                    .toList(),
              );

              return ListView.builder(
                itemCount: querySnapshot.documents.length,
                itemBuilder: (context, index) {
                  return Provider.of<ConversationsViewModel>(context)
                      .getListTile(index);
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
          Provider.of<ConversationsViewModel>(context, listen: false)
              .remove(item: item);
          await context.db.leaveConversation(item.conversationId);
        }
      },
      child: ListTile(
        leading: UserAvatar(url: item.photoURLs.first),
        title: Text(_combine(item.displayNames)),
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

  String _combine(List<String> displayNames) {
    var combinedNames = displayNames[0];
    for (var i = 1; i < displayNames.length; i++) {
      combinedNames += ', ' + displayNames[i];
    }
    return combinedNames;
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

class ConversationsViewModel extends ChangeNotifier {
  ConversationsViewModel(List<ConversationItem> items) : _items = items;

  /// Internal, private state of the model.
  final List<ConversationItem> _items;

  /// Unmodifiable view of the widgets in the model.
  Widget getListTile(int index) => ConversationsListTile(item: _items[index]);

  /// Adds a ConversationItem to the view model.
  void add({@required ConversationItem item}) {
    _items.add(item);
    // Tell the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes a ConversationItem from the view model.
  void remove({@required ConversationItem item}) {
    _items.remove(item);
    // Tell the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Sets the list of conversations
  void populateWith(List<ConversationItem> models) {
    _items.clear();
    _items.addAll(models);
  }
}
