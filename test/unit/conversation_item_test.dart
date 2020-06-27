import 'package:adventures_in_chat_app/models/conversation_item.dart';
import 'package:test/test.dart';

void main() {
  group('ConversationItem', () {
    test(
        '.truncatedNames() combines the display names and truncates to the given cutoff',
        () {
      final item = ConversationItem(
          conversationId: 'id',
          displayNames: ['a', 'b', 'c'],
          photoURLs: ['u', 'r', 'l'],
          uids: ['1', '2', '3']);

      expect(item.truncatedNames(4), 'a, b...');
    });
  });
}
