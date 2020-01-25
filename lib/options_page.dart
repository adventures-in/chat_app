import 'package:flutter/material.dart';

List<String> options = ["View Profile", "Message Requests", "Account Settings", "Logout"];
List<Icon> icons = [Icon(Icons.account_circle, size: 45), Icon(Icons.textsms, size: 45), Icon(Icons.exit_to_app, size: 45)];

class optionsPage extends StatefulWidget {
  @override
  _optionsPageState createState() => _optionsPageState();
}

class _optionsPageState extends State<optionsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ListView.builder(
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              return new ListTile(
                leading: icons[index],
                title: Text(options[(index)]),
              );
            }
        ),
      ),
    );
  }
}
