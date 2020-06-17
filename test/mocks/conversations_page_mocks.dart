import 'package:adventures_in_chat_app/conversations_page.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:adventures_in_chat_app/models/conversation_item.dart';

class FakeConversationsViewModel implements ConversationsViewModel {
  @override
  void add({ConversationItem item}) {
    // TODO: implement add
  }

  @override
  void addListener(item) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Widget getListTile(ConversationItem item) {
    // TOitem}) {
    // TODO: implement getListTile
    throw UnimplementedError();
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void populateWith(ConversationItem item) {
    // TODO: implement populateWith
  }

  @override
  void removeListener(item) {
    // TODO: implement removeListener
  }
}
