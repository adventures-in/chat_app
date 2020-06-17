import 'package:adventures_in_chat_app/conversations_page.dart';
import 'package:adventures_in_chat_app/models/conversation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'chat_page_test.dart';

import 'mocks/database_service_mocks.dart';

void main() {
  group('ConversationsList', () {
    testWidgets('preexisting conversationId, uids, displaynames and photoURLs',
        (WidgetTester tester) async {
      final db = FakeQuerySnapshotDatabaseService();

      await tester.pumpWidget(
        wrapWidget(
          Provider<FakeQuerySnapshotDatabaseService>.value(
            value: db,
            child: ConversationsPage(),
          ),
        ),
      );

      db.add([
        ConversationItem(
            conversationId: 'abc123',
            uids: ['123', '456'],
            displayNames: ['Leon', 'Noel'],
            photoURLs: ['https://url1', 'https://url2'])
      ]);

      await tester.pumpAndSettle();

      expect(find.text('Noel'), findsOneWidget);
    });
  });
}
