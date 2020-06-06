import 'package:adventures_in_chat_app/models/message.dart';
import 'package:adventures_in_chat_app/models/user_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

extension Conversion on DocumentSnapshot {
  Message toMessage() {
    return Message(
      authorId: data['authorId'] as String,
      text: data['text'] as String,
      timestamp: ((data['timestamp'] as Timestamp) ?? Timestamp.now()).toDate(),
    );
  }

  UserItem toUserItem() {
    return UserItem(
        uid: documentID,
        displayName: data['displayName'] as String,
        photoURL: data['photoURL'] as String);
  }
}
