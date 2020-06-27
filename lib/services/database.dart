import 'package:adventures_in_chat_app/models/conversation_item.dart';
import 'package:adventures_in_chat_app/models/message.dart';
import 'package:adventures_in_chat_app/models/user_item.dart';
import 'package:meta/meta.dart';

abstract class Database {
  Stream<List<Message>> getMessagesStream(String conversationId);

  Future<String> sendMessage({
    @required String text,
    @required String userId,
    @required String conversationId,
  });

  Future<ConversationItem> createConversation(String userId, List<String> uids,
      List<String> displayNames, List<String> photoURLs);

  Future<UserItem> getCurrentUserFuture(String userId);

  Stream<UserItem> getCurrentUserStream(String userId);

  Stream<List<ConversationItem>> getConversationsStream(String userId);

  Future<void> leaveConversation(String conversationId, String userId);
}
