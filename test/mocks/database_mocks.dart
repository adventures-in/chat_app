import 'package:adventures_in_chat_app/models/user_item.dart';
import 'package:adventures_in_chat_app/models/message.dart';
import 'package:adventures_in_chat_app/models/conversation_item.dart';
import 'package:adventures_in_chat_app/services/database.dart';

class FakeDatabase implements Database {
  final List<ConversationItem> _conversationItems;

  FakeDatabase({List<ConversationItem> conversationItems})
      : _conversationItems = conversationItems ?? [];

  void add(ConversationItem item) => _conversationItems.add(item);

  @override
  Future<ConversationItem> createConversation(String userId, List<String> uids,
      List<String> displayNames, List<String> photoURLs) {
    // TODO: implement createConversation
    throw UnimplementedError();
  }

  @override
  Stream<List<ConversationItem>> getConversationsStream(String userId) =>
      Stream.fromIterable([_conversationItems]);

  @override
  Future<UserItem> getCurrentUserFuture(String userId) {
    // TODO: implement getCurrentUserFuture
    throw UnimplementedError();
  }

  @override
  Stream<UserItem> getCurrentUserStream(String userId) => Stream.fromIterable([
        UserItem(
            uid: 'uid',
            displayName: 'name',
            photoURL:
                'https://lh3.googleusercontent.com/a-/AOh14GgcLuTiYf_wdIIMAw5CPaBDQowtVTHczbRV8eZrIQ=s96-c')
      ]);

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
