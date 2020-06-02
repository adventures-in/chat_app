import 'package:adventures_in_chat_app/extensions/extensions.dart';
import 'package:adventures_in_chat_app/models/conversation_item.dart';
import 'package:adventures_in_chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  final Firestore firestore;

  DatabaseService(this.firestore);

  Stream<List<ConversationItem>> getConversationsStream(String userId) =>
      firestore
          .collection('conversations')
          .where('uids', arrayContains: userId)
          .snapshots()
          .map((QuerySnapshot snapshot) => snapshot.documents
              .map((document) => document.toConversationItem())
              .toList());

  Stream<List<Message>> getMessagesStream(String conversationId) => firestore
      .collection('conversations/$conversationId/messages')
      .orderBy('timestamp', descending: false)
      .snapshots()
      .map((QuerySnapshot snapshot) =>
          snapshot.documents.map((document) => document.toMessage()).toList());

  Future<String> sendMessage({
    @required String text,
    @required String userId,
    @required String conversationId,
  }) =>
      firestore
          .collection('conversations')
          .document(conversationId)
          .collection('messages')
          .add(<String, dynamic>{
        'authorId': userId,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      }).then((documentReference) => documentReference.documentID);
}
