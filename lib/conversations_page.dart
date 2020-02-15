import 'package:flutter/material.dart';
import 'package:meetup_chatapp/chat_page.dart';

class ConversationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        leading: Icon(Icons.account_circle, size: 50),
        title: Text("Adventures.in Messenger"),
        actions: <Widget>[
          Icon(Icons.exit_to_app, size: 40),
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
  List<String> userNames = ["Chirs David", "Brin Page", "Harry Shane"];
  List<String> mockMessages = [
    "Hey there,",
    "Message me when free.",
    "Happy Birthday !"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ListView.builder(
            itemCount: userNames.length,
            itemBuilder: (BuildContext context, int index) {
              return new ListTile(
                leading: Icon(Icons.account_circle, size: 45),
                title: Text(userNames[index]),
                subtitle: Text(mockMessages[index]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatPage(
                              username: userNames[index],
                            )),
                  );
                },
              );
            }),
      ),
    );
  }
}
