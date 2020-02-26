import 'package:flutter/material.dart';
import 'package:meetup_chatapp/conversations_page.dart';
import 'package:meetup_chatapp/options_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          ConversationsPage(),
          OptionsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.chat), title: Text("Chats")),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text("Settings")),
        ],
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Theme.of(context).accentColor,
      ),
    );
  }
}
