import 'package:adventures_in_chat_app/chat_page.dart';
import 'package:adventures_in_chat_app/widgets/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatMessage', () {
    testWidgets('Should contain display text content',
        (WidgetTester tester) async {
      await tester.pumpWidget(wrapWidget(ChatMessage(
        text: 'Test message',
      )));

      final textFinder = find.text('Test message');

      expect(textFinder, findsOneWidget);
    });
  });

  group('BottomChatBar', () {
    testWidgets('Should contain a "send" button and a text input field',
        (WidgetTester tester) async {
      await tester.pumpWidget(wrapWidget(BottomChatBar(
        conversationId: null,
        currentUserId: null,
      )));

      final buttonFinder = find.byType(IconButton);
      final inputFinder = find.byType(TextField);

      expect(buttonFinder, findsOneWidget);
      expect(inputFinder, findsOneWidget);
    });
  });

  group('ChatPage', () {
    testWidgets('Should contain a list of messages and a bottom bar',
        (WidgetTester tester) async {
      // TODO add tests for ChatPage
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
