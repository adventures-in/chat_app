import 'package:adventures_in_chat_app/extensions/extensions.dart';
import 'package:adventures_in_chat_app/models/conversation_item.dart';
import 'package:adventures_in_chat_app/models/message.dart';
import 'package:adventures_in_chat_app/models/user_item.dart';
import 'package:adventures_in_chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FirestoreDatabase implements Database {
  final FirebaseFirestore _firestore;

  FirestoreDatabase({FirebaseFirestore firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Message>> getMessagesStream(String conversationId) => _firestore
      .collection('conversations/$conversationId/messages')
      .orderBy('timestamp', descending: false)
      .snapshots()
      .map((QuerySnapshot snapshot) =>
          snapshot.docs.map((document) => document.toMessage()).toList());

  @override
  Future<String> sendMessage({
    @required String text,
    @required String userId,
    @required String conversationId,
  }) =>
      _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .add(<String, dynamic>{
        'authorId': userId,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      }).then((documentReference) => documentReference.id);

  @override
  Future<ConversationItem> createConversation(String userId, List<String> uids,
      List<String> displayNames, List<String> photoURLs) async {
    // add the current user before saving to _firestore
    final item = await getCurrentUserFuture(userId);
    uids.add(item.uid);
    displayNames.add(item.displayName);
    photoURLs.add(item.photoURL);

    // save everything to _firestore
    final docRef =
        await _firestore.collection('conversations').add(<String, dynamic>{
      'createdOn': FieldValue.serverTimestamp(),
      'createdById': userId,
      'uids': uids,
      'displayNames': displayNames,
      'photoURLs': photoURLs
    });

    return ConversationItem(
        conversationId: docRef.id,
        displayNames: displayNames,
        photoURLs: photoURLs,
        uids: uids);
  }

  @override
  Future<UserItem> getCurrentUserFuture(String userId) => _firestore
      .doc('users/$userId')
      .get()
      .then((DocumentSnapshot snapshot) => snapshot.toUserItem());

  @override
  Stream<UserItem> getCurrentUserStream(String userId) => _firestore
      .doc('users/$userId')
      .snapshots()
      .map((DocumentSnapshot snapshot) => snapshot.toUserItem());

  @override
  Stream<List<ConversationItem>> getConversationsStream(String userId) =>
      _firestore
          .collection('conversations')
          .where('uids', arrayContains: userId)
          .snapshots()
          .map(
            (querySnapshot) => querySnapshot.docs
                .map(
                  (itemDoc) => ConversationItem(
                      conversationId: itemDoc.id,
                      uids: List.from(itemDoc.get('uids') as List),
                      displayNames:
                          List.from(itemDoc.get('displayNames') as List),
                      photoURLs: List.from(itemDoc.get('photoURLs') as List)),
                )
                .toList(),
          );

  @override
  Future<void> leaveConversation(String conversationId, String userId) async {
    await _firestore
        .doc('conversations/$conversationId/leave/$userId')
        .set(<String, dynamic>{'leftOn': FieldValue.serverTimestamp()});
  }
}
