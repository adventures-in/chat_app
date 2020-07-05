import 'package:adventures_in_chat_app/extensions/extensions.dart';

abstract class MessagesListItem {
  String get outputText;
}

class SectionDate implements MessagesListItem {
  final DateTime timestamp;

  SectionDate(this.timestamp);

  @override
  String get outputText => timestamp.printDate();
}

class Message implements MessagesListItem {
  final String authorId;
  final String text;
  final DateTime timestamp;

  Message({
    this.authorId,
    this.text,
    this.timestamp,
  });

  @override
  String get outputText => text;
}
