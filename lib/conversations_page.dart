import 'package:adventures_in_chat_app/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:adventures_in_chat_app/chat_page.dart';
import 'package:adventures_in_chat_app/models/conversation_item.dart';
import 'package:adventures_in_chat_app/models/user_item.dart';
import 'package:adventures_in_chat_app/user_search_page.dart';
import 'package:adventures_in_chat_app/widgets/user_avatar.dart';
import 'package:provider/provider.dart';

class ConversationsPage extends StatelessWidget {
  final DatabaseService db;

  const ConversationsPage({
    Key key,
    @required this.db,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<FirebaseUser>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: UserAvatar(url: currentUser.photoUrl),
        title: Text('Conversations'),
        actions: <Widget>[],
      ),
      body: Center(
        child: StreamBuilder<List<ConversationItem>>(
            stream: db.getConversationsStream(currentUser.uid),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();

              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) =>
                    ConversationsListTile(item: snapshot.data[index]),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push<ConversationItem>(
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
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
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
