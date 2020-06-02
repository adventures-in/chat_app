import 'package:adventures_in_chat_app/models/conversation_item.dart';
import 'package:adventures_in_chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

extension MessageConversion on DocumentSnapshot {
  Message toMessage() {
    return Message(
      authorId: data['authorId'] as String,
      text: data['text'] as String,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}

extension ConversationItemConversion on DocumentSnapshot {
  ConversationItem toConversationItem() {
    return ConversationItem(
      conversationId: documentID,
      uids: List.from(data['uids'] as List),
      displayNames: List.from(data['displayNames'] as List),
      photoURLs: List.from(data['photoURLs'] as List),
    );
  }
}
