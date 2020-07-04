import 'package:adventures_in_chat_app/widgets/messages/chat_page.dart';
import 'package:adventures_in_chat_app/models/conversation_item.dart';
import 'package:adventures_in_chat_app/models/message.dart';
import 'package:adventures_in_chat_app/services/database_service.dart';
import 'package:adventures_in_chat_app/widgets/messages/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDatabaseService extends Mock implements DatabaseService {
  MockDatabaseService();
}

void main() {
  group('ChatMessage', () {
    testWidgets('Should contain text content', (WidgetTester tester) async {
      await tester.pumpWidget(wrapWidget(ChatMessage(text: 'Test message')));

      expect(find.text('Test message'), findsOneWidget);
    });

    testWidgets('Should contain dateTime in chat widget when specified',
        (WidgetTester tester) async {
      var dateTime = DateTime.parse('1969-07-20 20:18:04Z');
      var formattedDate = '1969-7-20 20:18';

      await tester.pumpWidget(
          wrapWidget(ChatMessage(text: 'Test message', dateTime: dateTime)));

      expect(find.text('Test message'), findsOneWidget);
      expect(find.text(formattedDate), findsOneWidget);
    });
  });

  group('BottomChatBar', () {
    testWidgets('Should contain a "send" button and a text input field',
        (WidgetTester tester) async {
      await tester.pumpWidget(wrapWidget(BottomChatBar(
        onSubmit: (String text) {},
      )));

      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('Should return text on submit', (WidgetTester tester) async {
      String result;

      await tester.pumpWidget(wrapWidget(BottomChatBar(
        onSubmit: (String text) => result = text,
      )));

      await tester.enterText(find.byType(TextField), 'Test message');
      expect(find.text('Test message'), findsOneWidget);
      await tester.tap(find.byType(IconButton));

      expect(result, 'Test message');
    });
  });

  group('ChatPage', () {
    testWidgets('Should contain an empty container and a bottom bar',
        (WidgetTester tester) async {
      final db = MockDatabaseService();

      await tester.pumpWidget(wrapWidget(ChatPage(
        db: db,
        conversationItem: ConversationItem(
          displayNames: null,
          conversationId: 'testId',
          photoURLs: null,
          uids: null,
        ),
        currentUserId: null,
      )));

      await tester.pumpAndSettle();

      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(BottomChatBar), findsOneWidget);
    });

    testWidgets('Should contain a list of messages when available',
        (WidgetTester tester) async {
      final db = MockDatabaseService();
      final messages = [
        Message(text: 'Message1'),
        Message(text: 'Message2'),
        Message(text: 'Message3'),
      ];

      when(db.getMessagesStream('testId'))
          .thenAnswer((_) => Stream<List<Message>>.value(messages));

      await tester.pumpWidget(wrapWidget(ChatPage(
        db: db,
        conversationItem: ConversationItem(
          displayNames: null,
          conversationId: 'testId',
          photoURLs: null,
          uids: null,
        ),
        currentUserId: null,
      )));

      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ChatMessage), findsNWidgets(messages.length));
    });

    testWidgets('Should send a message when submit is pressed',
        (WidgetTester tester) async {
      final db = MockDatabaseService();
      final testMessage = 'Test message';
      final testConversationId = 'testConversationId';
      final testUsers = ['testUser1', 'testUser2'];

      await tester.pumpWidget(wrapWidget(ChatPage(
        db: db,
        conversationItem: ConversationItem(
          displayNames: null,
          conversationId: testConversationId,
          photoURLs: null,
          uids: testUsers,
        ),
        currentUserId: testUsers[0],
      )));

      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), testMessage);
      await tester.tap(find.byType(IconButton));

      verify(db.sendMessage(
        text: testMessage,
        userId: testUsers[0],
        conversationId: testConversationId,
      ));
    });
  });
}

Widget wrapWidget(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: child,
    ),
  );
}
