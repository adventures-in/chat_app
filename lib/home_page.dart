import 'package:adventures_in_chat_app/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:adventures_in_chat_app/conversations_page.dart';
import 'package:adventures_in_chat_app/options_page.dart';

class HomePage extends StatefulWidget {
  final DatabaseService db;

  const HomePage({
    Key key,
    @required this.db,
  }) : super(key: key);

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
          ConversationsPage(
            db: widget.db,
          ),
          OptionsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.chat), title: Text('Chats')),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text('Settings')),
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
