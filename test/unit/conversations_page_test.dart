// Import the test package and Counter class
import 'package:adventures_in_chat_app/conversations_page.dart';
import 'package:adventures_in_chat_app/models/conversation_item.dart';
import 'package:test/test.dart';

void main() {
  group('group', () {
    test('test ConversationViewModel add', () {
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
    test('test ConversationViewModel populateWith', () {
      var inject_list = <ConversationItem>[];
      var vm = ConversationsViewModel(inject_list); // start with empty list
      var instance = ConversationItem(
          conversationId: 'abc123',
          uids: ['123', '456'],
          displayNames: ['Leon', 'Noel'],
          photoURLs: ['https://url1', 'https://url2']);
      var alternate_list = <ConversationItem>[];
      alternate_list.add(instance);

      vm.populateWith(alternate_list);
      expect(inject_list, alternate_list);
    });
  });
}
