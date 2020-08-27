import 'package:adventures_in_chat_app/widgets/messages/chat_page.dart';
import 'package:adventures_in_chat_app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MessagesList', () {
    testWidgets('Should display the bottom message on load',
        (WidgetTester tester) async {
      final _controller = ScrollController();
      final messages = <Message>[];
      for (var i = 0; i <= 20; i++) {
        messages.add(Message(authorId: 'id', text: 'message $i'));
      }
      await tester.pumpWidget(MaterialApp(
          home: MessagesList(
        controller: _controller,
        items: messages,
      )));

      await tester.pumpAndSettle();

      expect(find.text('message 20'), findsOneWidget);
    });
  });
}
