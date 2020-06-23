import 'dart:async';

import 'package:adventures_in_chat_app/models/conversation_item.dart';
import 'package:adventures_in_chat_app/services/database_service.dart';
import 'package:mockito/mockito.dart';

class FakeQuerySnapshotDatabaseService extends Fake implements DatabaseService {
  final controller = StreamController<List<ConversationItem>>();

  @override
  Stream<List<ConversationItem>> getConversationsStream() => controller.stream;

  void add(List<ConversationItem> conversations) =>
      controller.add(conversations);

  void close() {
    controller.close();
  }
}
