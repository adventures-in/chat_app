import 'package:adventures_in_chat_app/models/user_item.dart';
import 'package:adventures_in_chat_app/models/message.dart';
import 'package:adventures_in_chat_app/models/conversation_item.dart';
import 'package:adventures_in_chat_app/services/database.dart';

/// Holds a List of [ConversationItem] that is used to provide a stream.
///
/// Also provides a stream of [UserItem], currently implemented as a stream
/// that emits a single user.
class FakeDatabase implements Database {
  final List<ConversationItem> _conversationItems;

  /// Use an optional named parameter to set [_conversationItems] or leave
  /// empty to create with an empty list
  FakeDatabase({List<ConversationItem> conversationItems})
      : _conversationItems = conversationItems ?? [];

  /// allows easy adding of items to the items list
  void add(ConversationItem item) => _conversationItems.add(item);

  /// Returns a stream created from the items list
  @override
  Stream<List<ConversationItem>> getConversationsStream(String userId) =>
      Stream.fromIterable([_conversationItems]);

  /// Returns a stream that emits a single [UserItem]
  @override
  Stream<UserItem> getCurrentUserStream(String userId) => Stream.fromIterable([
        UserItem(
            uid: 'uid',
            displayName: 'name',
            photoURL: 'https://example.com/name.png')
      ]);

  @override
  Future<ConversationItem> createConversation(String userId, List<String> uids,
      List<String> displayNames, List<String> photoURLs) {
    // TODO: implement createConversation
    throw UnimplementedError();
  }

  @override
  Future<UserItem> getCurrentUserFuture(String userId) {
    // TODO: implement getCurrentUserFuture
    throw UnimplementedError();
  }

  @override
  Stream<List<Message>> getMessagesStream(String conversationId) {
    // TODO: implement getMessagesStream
    throw UnimplementedError();
  }

  @override
  Future<String> sendMessage(
      {String text, String userId, String conversationId}) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }
}
