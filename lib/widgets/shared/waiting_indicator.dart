import 'package:flutter/material.dart';

class WaitingIndicator extends StatelessWidget {
  final String message;
  const WaitingIndicator(
    this.message, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(height: 15),
          Text(message)
        ],
      ),
    );
  }
}
