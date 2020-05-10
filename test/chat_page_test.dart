import 'package:adventures_in_chat_app/chat_page.dart';
import 'package:adventures_in_chat_app/models/conversation_item.dart';
import 'package:adventures_in_chat_app/models/message.dart';
import 'package:adventures_in_chat_app/services/api.dart';
import 'package:adventures_in_chat_app/widgets/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockApi extends Mock implements Api {
  MockApi(CollectionGet collectionGet);
}

void main() {
  group('ChatMessage', () {
    testWidgets('Should contain text content',
        (WidgetTester tester) async {
      await tester.pumpWidget(wrapWidget(ChatMessage(
        text: 'Test message',
      )));

      expect(find.text('Test message'), findsOneWidget);
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
      final api = MockApi(null);

      await tester.pumpWidget(wrapWidget(ChatPage(
        api: api,
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
      final api = MockApi(null);
      final messages = [
        Message(text: 'Message1'),
        Message(text: 'Message2'),
        Message(text: 'Message3'),
      ];

      when(api.getMessagesStream('testId'))
          .thenAnswer((_) => Stream<List<Message>>.value(messages));

      await tester.pumpWidget(wrapWidget(ChatPage(
        api: api,
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
  });
}

Widget wrapWidget(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: child,
    ),
  );
}
