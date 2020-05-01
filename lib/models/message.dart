import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String authorId;
  final String text;
  final DateTime timestamp;

  Message({
    this.authorId,
    this.text,
    this.timestamp,
  });

  factory Message.fromDocument(DocumentSnapshot document) {
    var data = document.data;

    return Message(
      authorId: data['authorId'] as String,
      text: data['text'] as String,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
