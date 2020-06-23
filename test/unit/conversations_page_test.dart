import 'package:adventures_in_chat_app/conversations_page.dart';
import 'package:adventures_in_chat_app/models/conversation_item.dart';
import 'package:test/test.dart';

void main() {
  group('ConversationsViewModel', () {
    test('.add() adds an item to the items list', () {
      // create an empty list and pass in to a new vm
      var inject_list = <ConversationItem>[];
      var vm = ConversationsViewModel(inject_list);

      // create an item and add the to the vm
      var instance = ConversationItem(
          conversationId: 'abc123',
          uids: ['123', '456'],
          displayNames: ['Leon', 'Noel'],
          photoURLs: ['https://url1', 'https://url2']);
      vm.add(item: instance);

      // check the vm has the item
      expect(inject_list, [instance]);
    });

    test('.populateWith() replaces the items list with the passed in list', () {
      // create an empty list and pass in to a new vm
      var inject_list = <ConversationItem>[];
      var vm = ConversationsViewModel(inject_list);

      // create a new list with a single item
      var instance = ConversationItem(
          conversationId: 'abc123',
          uids: ['123', '456'],
          displayNames: ['Leon', 'Noel'],
          photoURLs: ['https://url1', 'https://url2']);
      var alternate_list = <ConversationItem>[];
      alternate_list.add(instance);

      // call populateWith and check the injected list has the same contents as
      // the new list, ie. the vm was updated as expected
      vm.populateWith(alternate_list);
      expect(inject_list, alternate_list);
    });

    test('.populateWith() does not replace items list if non-empty', () {
      // create an empty list and pass in to a new vm
      var inject_list = <ConversationItem>[];
      var vm = ConversationsViewModel(inject_list);

      // create an item and add to a new list
      var instance = ConversationItem(
          conversationId: 'abc123',
          uids: ['123', '456'],
          displayNames: ['Leon', 'Noel'],
          photoURLs: ['https://url1', 'https://url2']);
      var alternate_list = <ConversationItem>[];
      alternate_list.add(instance);

      // call populateWith and check the vm was updated
      vm.populateWith(alternate_list);
      expect(inject_list, alternate_list);

      // create another item and add to another new list
      var second_instance = ConversationItem(
          conversationId: 'def456',
          uids: ['456', '789'],
          displayNames: ['Noel', 'Richard'],
          photoURLs: ['https://url2', 'https://url3']);
      var second_alternative_list = <ConversationItem>[];
      second_alternative_list.add(second_instance);

      // call populateWith again and check the vm was not updated again
      vm.populateWith(second_alternative_list);
      expect(inject_list, alternate_list);
    });
  });
}
