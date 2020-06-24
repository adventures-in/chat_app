import 'package:adventures_in_chat_app/conversations_page.dart';
import 'package:adventures_in_chat_app/models/conversation_item.dart';
import 'package:adventures_in_chat_app/services/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'chat_page_test.dart';
import 'mocks/database_mocks.dart';
import 'utils/image_test_utils.dart';

void main() {
  group('ConversationsPage', () {
    testWidgets('should show combined display names',
        (WidgetTester tester) async {
      final fake = FakeDatabase();
      final item = ConversationItem(conversationId: 'abc123', uids: [
        '123',
        '456'
      ], displayNames: [
        'Leon',
        'Noel'
      ], photoURLs: [
        'https://example.com/leon.png',
        'https://example.com/noel.png'
      ]);
      fake.add(item);

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

        expect(find.text(item.truncatedNames(15)), findsOneWidget);
      });
    });

    testWidgets('should show the string \'null\' when a displayName is null',
        (WidgetTester tester) async {
      final fake = FakeDatabase();
      final item = ConversationItem(conversationId: 'abc123', uids: [
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
      fake.add(item);

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

        expect(find.text(item.truncatedNames(15)), findsOneWidget);
      });
    });
  });
}
