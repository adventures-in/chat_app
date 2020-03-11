import 'package:flutter/material.dart';

/// A conversation item used in lists, has the minimal info needed to
/// display a conversation item
class ConversationItem {
  ConversationItem(
      {@required this.conversationId,
      @required this.uids,
      @required this.displayNames,
      @required this.photoURLs});

  final String conversationId;
  final List<String> uids;
  final List<String> displayNames;
  final List<String> photoURLs;

  // Conversation items with the same conversationId are considered equivalent
  bool operator ==(dynamic o) =>
      o.runtimeType == ConversationItem && o.id == conversationId;
  int get hashCode => conversationId.hashCode;
}
