import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String text;

  const ChatMessage({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(text,
                style: theme.textTheme.bodyText1.merge(TextStyle(
                    fontSize: 20,
                    background: Paint()
                      ..strokeWidth = 30.0
                      ..color = theme.backgroundColor
                      ..style = PaintingStyle.stroke
                      ..strokeJoin = StrokeJoin.round)))),
      ],
    );
  }
}
