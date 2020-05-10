import 'package:adventures_in_chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

typedef CollectionGet = CollectionReference Function(String path);

class Api {
  final CollectionGet collectionGet;

  Api(this.collectionGet);

  Stream<List<Message>> getMessagesStream(String conversationId) =>
      collectionGet('conversations/$conversationId/messages')
          .orderBy('timestamp', descending: false)
          .snapshots()
          .map((QuerySnapshot snapshot) => snapshot.documents
              .map((document) => Message.fromDocument(document))
              .toList());

  Future<String> sendMessage({
    @required String text,
    @required String userId,
    @required String conversationId,
  }) =>
      collectionGet('conversations')
          .document(conversationId)
          .collection('messages')
          .add(<String, dynamic>{
        'authorId': userId,
        'text': text,
        'timestamp': FieldValue.serverTimestamp()
      }).then((documentReference) => documentReference.documentID);
}
