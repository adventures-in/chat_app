import 'package:adventures_in_chat_app/models/conversations_view_model.dart';
import 'package:adventures_in_chat_app/services/database_service.dart';
import 'package:adventures_in_chat_app/widgets/conversations/conversations_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../data/conversation_item_data.dart';
import '../mocks/database_mocks.dart';
import '../utils/image_test_utils.dart';
import '../utils/widget_test_utils.dart';

void main() {
  group('ConversationsPage', () {
    testWidgets('should show combined display names',
        (WidgetTester tester) async {
      final fake = FakeDatabase();
      final item = createAConversationItem();
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
      final item = createAConversationItem();
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
