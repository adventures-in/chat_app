import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meetup_chatapp/chat_page.dart';
import 'package:meetup_chatapp/options_page.dart';
import 'package:provider/provider.dart';

class ConversationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            ProfileAvatar(url: Provider.of<FirebaseUser>(context).photoUrl),
        title: Text("Chats"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OptionsPage()));
              }),
        ],
      ),

      body: ConversationList(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
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
    Map<String, dynamic> conversationsMap = {};

    return Container(
      child: Center(
        child: StreamBuilder(
            stream: Firestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              QuerySnapshot querySnapshot = snapshot.data;

              for (DocumentSnapshot docSnapshot in querySnapshot.documents) {
                if (docSnapshot.documentID ==
                    Provider.of<FirebaseUser>(context).uid) {
                  if (docSnapshot.data['conversationsMap'] != null) {
                    conversationsMap = docSnapshot.data['conversationsMap'];
                  }
                  break;
                }
              }

              return ListView.builder(
                itemCount: querySnapshot.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> docData =
                      querySnapshot.documents[index].data;
                  String tappedUserId =
                      querySnapshot.documents[index].documentID;
                  return ListTile(
                      leading: ProfileAvatar(url: docData['photoURL']),
                      title: Text(docData['displayName']),
                      subtitle: Text('Coming soon.'),
                      onTap: () {
                        final tappedUser = docData;
                        Navigator.pushNamed(context, ChatPage.routeName,
                            arguments: ChatPageArgs(
                                currentUserId: Provider.of<FirebaseUser>(
                                        context,
                                        listen: false)
                                    .uid,
                                tappedUsername: tappedUser['displayName'],
                                conversationId: conversationsMap[tappedUserId],
                                tappedUserId: tappedUserId));
                      });
                },
              );
            }),
      ),
    );
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
