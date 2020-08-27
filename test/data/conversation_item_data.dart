import 'package:adventures_in_chat_app/models/conversation_item.dart';

ConversationItem createAConversationItem() =>
    ConversationItem(conversationId: 'abc123', uids: [
      '123',
      '456',
      'abc'
    ], displayNames: [
      'Leon',
      'Noel',
      null
    ], photoURLs: [
      'https://example.com/leon.png',
      'https://example.com/noel.png',
      'https://example.com/null.png',
    ]);
