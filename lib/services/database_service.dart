import 'dart:async';

import 'package:adventures_in_chat_app/models/conversation_item.dart';
import 'package:adventures_in_chat_app/models/message.dart';
import 'package:adventures_in_chat_app/models/user_item.dart';
import 'package:adventures_in_chat_app/services/database.dart';
import 'package:adventures_in_chat_app/services/firestore_database.dart';
import 'package:flutter/foundation.dart';

import 'package:adventures_in_chat_app/extensions/extensions.dart';

class DatabaseService {
  String currentUserId;
  final Database _database;
  final _controller = StreamController<List<MessagesListItem>>();

  DatabaseService({Database database})
      : _database = database ?? FirestoreDatabase();

  Stream<List<MessagesListItem>> getMessagesStream(String conversationId) {
    _database.getMessagesStream(conversationId).listen((messagesList) {
      var latest = messagesList.first.timestamp;
      final newList = <MessagesListItem>[SectionDate(latest)];
      for (final message in messagesList) {
        // if message is first in a new day - insert SectionDate
        if (!message.timestamp.isSameDate(latest)) {
          latest = message.timestamp;
          newList.add(SectionDate(latest));
        }
        newList.add(message);
      }
      _controller.add(newList);
    });

    return _controller.stream;
  }

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
