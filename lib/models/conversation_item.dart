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

  // generate a truncated string of the combined display names
  String truncatedNames(int cutoff) {
    final joined = displayNames?.join(', ') ?? '';
    return (joined.length <= cutoff)
        ? joined
        : '${joined.substring(0, cutoff)}...';
  }

  // Conversation items with the same conversationId are considered equivalent
  @override
  bool operator ==(dynamic o) =>
      o.runtimeType == ConversationItem && o.conversationId == conversationId;
  @override
  int get hashCode => conversationId.hashCode;
}
