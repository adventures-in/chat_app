// Import the test package and Counter class
import 'package:adventures_in_chat_app/conversations_page.dart';
import 'package:adventures_in_chat_app/models/conversation_item.dart';
import 'package:test/test.dart';

void main() {
  group('group', () {
    test('test ViewModel', () {
      var inject_list = <ConversationItem>[];
      var vm = ConversationsViewModel(inject_list);
      var instance = ConversationItem(
          conversationId: 'abc123',
          uids: ['123', '456'],
          displayNames: ['Leon', 'Noel'],
          photoURLs: ['https://url1', 'https://url2']);
      vm.add(item: instance);
      expect(inject_list, [instance]);
    });
  });
}
