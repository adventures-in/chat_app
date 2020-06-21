import 'package:adventures_in_chat_app/conversations_page.dart';
import 'package:adventures_in_chat_app/models/conversation_item.dart';
import 'package:adventures_in_chat_app/services/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'chat_page_test.dart';
import 'mocks/database_mocks.dart';
import 'utils/image_test_utils.dart';

void main() {
  group('ConversationsList', () {
    testWidgets('find conversationId, uids, displaynames and photoURLs',
        (WidgetTester tester) async {
      final fake = FakeDatabase();
      fake.add(ConversationItem(conversationId: 'abc123', uids: [
        '123',
        '456'
      ], displayNames: [
        'Leon',
        'Noel'
      ], photoURLs: [
        'https://example.com/leon.png',
        'https://example.com/noel.png'
      ]));

      final db = DatabaseService(database: fake);

      await provideMockedNetworkImages(() async {
        await tester.pumpWidget(wrapWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                  create: (context) => ConversationsViewModel([])),
              Provider<DatabaseService>.value(value: db),
            ],
            child: ConversationsPage(),
          ),
        ));

        await tester.pumpAndSettle();

        expect(find.text('Leon, Noel'), findsOneWidget);
      });
    });
    testWidgets('no exception when null displaynames',
        (WidgetTester tester) async {
      final fake = FakeDatabase();
      fake.add(ConversationItem(conversationId: 'abc123', uids: [
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
      ]));

      final db = DatabaseService(database: fake);

      await provideMockedNetworkImages(() async {
        await tester.pumpWidget(wrapWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                  create: (context) => ConversationsViewModel([])),
              Provider<DatabaseService>.value(value: db),
            ],
            child: ConversationsPage(),
          ),
        ));

        await tester.pumpAndSettle();

        expect(find.text('Leon, Noel, null'), findsOneWidget);
      });
    });
  });
}
