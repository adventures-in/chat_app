import 'package:adventures_in_chat_app/models/message.dart';
import 'package:adventures_in_chat_app/models/user_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

extension Conversion on DocumentSnapshot {
  Message toMessage() {
    return Message(
      authorId: get('authorId') as String,
      text: get('text') as String,
      timestamp: ((get('timestamp') as Timestamp) ?? Timestamp.now()).toDate(),
    );
  }

  UserItem toUserItem() {
    String displayName;
    String photoURL;
    if (data != null) {
      displayName = get('displayName') as String;
      photoURL = get('photoURL') as String;
    }
    return UserItem(uid: id, displayName: displayName, photoURL: photoURL);
  }
}
