import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final DateTime dateTime;

  const ChatMessage({Key key, this.text, this.dateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var formattedDate = (dateTime == null)
        ? ''
        : '${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}';

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                        ..strokeJoin = StrokeJoin.round))),
            ),
            Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(formattedDate,
                    style: theme.textTheme.bodyText1
                        .merge(TextStyle(fontSize: 12)))),
          ],
        ),
      ],
    );
  }
}
