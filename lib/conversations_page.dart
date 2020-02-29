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
    return Container(
      child: Center(
        child: FutureBuilder(
            future: Firestore.instance.collection('users').getDocuments(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              QuerySnapshot querySnapshot = snapshot.data;
              return ListView.builder(
                itemCount: querySnapshot.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> docData =
                      querySnapshot.documents[index].data;
                  return ListTile(
                      leading: ProfileAvatar(url: docData['photoURL']),
                      title: Text(docData['displayName']),
                      subtitle: Text('Coming soon.'),
                      onTap: () {
                        Navigator.pushNamed(context, ChatPage.routeName,
                            arguments: ChatPageArgs(
                              docData['displayName'],
                            ));
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
