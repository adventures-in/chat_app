import 'package:adventures_in_chat_app/chat_page.dart';
import 'package:adventures_in_chat_app/conversations_page.dart';
import 'package:adventures_in_chat_app/models/conversation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'chat_page_test.dart';

void main() {
  group('ConversationsList', () {
    testWidgets('conversationId, uids, displaynames and photoURLs',
        (WidgetTester tester) async {
      final db = MockDatabaseService();
      final conversationId = 'abc123';
      final uids = ['123', '456'];
      final displayNames = ['Leon', 'Noel'];
      final photoURLs = ['https://url1', 'https://url2'];

      await tester.pumpWidget(wrapWidget(ConversationsPage(db: db)));

      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), testMessage);
      await tester.tap(find.byType(IconButton));

      verify(db.sendMessage(
          conversationId: conversationId,
          uids: uids,
          displayNames: displayNames,
          photoURLs: photoURLs));
    });
  });
}
