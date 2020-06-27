import 'package:adventures_in_chat_app/models/conversation_item.dart';
import 'package:adventures_in_chat_app/models/message.dart';
import 'package:adventures_in_chat_app/models/user_item.dart';
import 'package:adventures_in_chat_app/services/database.dart';
import 'package:adventures_in_chat_app/services/firestore_database.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  String currentUserId;
  final Database _database;

  DatabaseService({Database database})
      : _database = database ?? FirestoreDatabase();

  Stream<List<Message>> getMessagesStream(String conversationId) =>
      _database.getMessagesStream(conversationId);

  Future<String> sendMessage({
    @required String text,
    @required String userId,
    @required String conversationId,
  }) =>
      _database.sendMessage(
          text: text, userId: userId, conversationId: conversationId);

  Future<ConversationItem> createConversation(List<String> uids,
          List<String> displayNames, List<String> photoURLs) =>
      _database.createConversation(
          currentUserId, uids, displayNames, photoURLs);

  Future<UserItem> getCurrentUserFuture() =>
      _database.getCurrentUserFuture(currentUserId);

  Stream<UserItem> getCurrentUserStream() =>
      _database.getCurrentUserStream(currentUserId);

  Stream<List<ConversationItem>> getConversationsStream() =>
      _database.getConversationsStream(currentUserId);

  Future<void> leaveConversation(String conversationId) =>
      _database.leaveConversation(conversationId, currentUserId);
}
