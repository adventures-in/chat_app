import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:meetup_chatapp/chat_page.dart';
import 'package:meetup_chatapp/options_page.dart';
import 'package:provider/provider.dart';

class ConversationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        ios: (context) =>
            CupertinoNavigationBarData(transitionBetweenRoutes: false),
        leading:
            ProfileAvatar(url: Provider.of<FirebaseUser>(context).photoUrl),
        title: Text("Chats"),
      ),
      body: ConversationList(),
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
    return FutureBuilder(
        future: Firestore.instance.collection('users').getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: PlatformCircularProgressIndicator(),
            );
          QuerySnapshot querySnapshot = snapshot.data;
          return ListView.builder(
            itemCount: querySnapshot.documents.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> docData =
                  querySnapshot.documents[index].data;
              return Material(
                  child: ListTile(
                      leading: ProfileAvatar(url: docData['photoURL']),
                      title: Text(docData['displayName']),
                      subtitle: Text('Coming soon.'),
                      onTap: () {
                        Navigator.pushNamed(context, ChatPage.routeName,
                            arguments: ChatPageArgs(
                              docData['displayName'],
                            ));
                      }));
            },
          );
        });
  }
}

class ProfileAvatar extends StatelessWidget {
  ProfileAvatar({@required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: NetworkImage(url),
    );
  }
}
