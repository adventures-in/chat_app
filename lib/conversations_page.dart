import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meetup_chatapp/chat_page.dart';
import 'package:meetup_chatapp/models/conversation_item.dart';
import 'package:meetup_chatapp/models/user_item.dart';
import 'package:meetup_chatapp/user_search_page.dart';
import 'package:meetup_chatapp/widgets/user_avatar.dart';
import 'package:provider/provider.dart';

class ConversationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<FirebaseUser>(context, listen: false);
    return ChangeNotifierProvider(
      create: (context) => ConversationsViewModel(),
      child: Scaffold(
        appBar: AppBar(
          leading: UserAvatar(url: currentUser.photoUrl),
          title: Text("Conversations"),
          actions: <Widget>[],
        ),
        body: ConversationList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final conversationItem = await Navigator.push<ConversationItem>(
              context,
              MaterialPageRoute(
                builder: (context) => UserSearchPage(
                  currentUserItem: UserItem(
                      uid: currentUser.uid,
                      displayName: currentUser.displayName,
                      photoURL: currentUser.photoUrl),
                ),
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
    final currentUserId = Provider.of<FirebaseUser>(context, listen: false).uid;
    return Container(
      child: Center(
        child: StreamBuilder(
            stream: Firestore.instance
                .collection('users/$currentUserId/conversation-items')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();

              final querySnapshot = snapshot.data as QuerySnapshot;
              Provider.of<ConversationsViewModel>(context).populateWith(
                querySnapshot.documents
                    .map(
                      (itemDoc) => ConversationItem(
                          conversationId:
                              itemDoc.data['conversationId'] as String,
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
    return ListTile(
      leading: UserAvatar(url: item.photoURLs.first),
      title: Text('and ${item.uids.length} others'),
      subtitle: Text('Coming soon.'),
      onTap: () {
        Navigator.pushNamed(context, ChatPage.routeName,
            arguments: ChatPageArgs(
                currentUserId:
                    Provider.of<FirebaseUser>(context, listen: false).uid,
                conversationItem: item));
      },
    );
  }
}

class ConversationsViewModel extends ChangeNotifier {
  /// Internal, private state of the model.
  final List<ConversationItem> _items = [];

  /// Unmodifiable view of the widgets in the model.
  Widget getListTile(int index) => ConversationsListTile(item: _items[index]);

  /// Adds a ConversationItem to the view model.
  /// The only way to modify the cart from outside.
  void add({@required ConversationItem item}) {
    _items.add(item);
    // Tell the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Adds all conversations, if we don't yet have any
  /// TODO: this is probably not what we want in this case, review when
  /// more of the page has been built
  void populateWith(List<ConversationItem> models) {
    if (_items.length == 0) {
      _items.addAll(models);
    }
  }
}
