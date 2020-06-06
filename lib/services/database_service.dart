import 'package:adventures_in_chat_app/extensions/extensions.dart';
import 'package:adventures_in_chat_app/models/conversation_item.dart';
import 'package:adventures_in_chat_app/models/message.dart';
import 'package:adventures_in_chat_app/models/user_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  final Firestore firestore;
  String currentUserId;

  DatabaseService(this.firestore);

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

  Future<ConversationItem> createConversation(List<String> uids,
      List<String> displayNames, List<String> photoURLs) async {
    // add the current user before saving to firestore
    final item = await getCurrentUserFuture();
    uids.add(item.uid);
    displayNames.add(item.displayName);
    photoURLs.add(item.photoURL);

    // save everything to firestore
    final docRef =
        await firestore.collection('conversations').add(<String, dynamic>{
      'createdOn': FieldValue.serverTimestamp(),
      'createdById': currentUserId,
      'uids': uids,
      'displayNames': displayNames,
      'photoURLs': photoURLs
    });

    return ConversationItem(
        conversationId: docRef.documentID,
        displayNames: displayNames,
        photoURLs: photoURLs,
        uids: uids);
  }

  Future<UserItem> getCurrentUserFuture() => firestore
      .document('users/$currentUserId')
      .get()
      .then((DocumentSnapshot snapshot) => snapshot.toUserItem());

  Stream<UserItem> getCurrentUserStream() => firestore
      .document('users/$currentUserId')
      .snapshots()
      .map((DocumentSnapshot snapshot) => snapshot.toUserItem());
}
