import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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
    return PlatformScaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          ConversationsPage(),
          OptionsPage(),
        ],
      ),
      bottomNavBar: PlatformNavBar(
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.chat), title: Text("Chats")),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text("Settings")),
        ],
        itemChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      iosContentBottomPadding: true,
    );
  }
}
