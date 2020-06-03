import 'package:adventures_in_chat_app/chat_page.dart';
import 'package:adventures_in_chat_app/models/conversation_item.dart';
import 'package:adventures_in_chat_app/models/message.dart';
import 'package:adventures_in_chat_app/services/database_service.dart';
import 'package:adventures_in_chat_app/widgets/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDatabase extends Mock implements DatabaseService {
  MockDatabase();
}

void main() {
  group('ChatMessage', () {
    testWidgets('Should contain text content', (WidgetTester tester) async {
      await tester.pumpWidget(wrapWidget(ChatMessage(text: 'Test message')));

      expect(find.text('Test message'), findsOneWidget);
    });

    test('datetime is defaulted to now() when firebase Timestamp is null', () {
      /// This logic closely mimics document_snapshot_extensions
      /// Should likely look at seperate firebase repo tests instead of copy / paste implementaion
      /// https://github.com/brianegan/flutter_architecture_samples/blob/master/firebase_flutter_repository/test/firebase_flutter_repository_test.dart
      var now = Timestamp.now().toDate();
      DateTime null_timestamp;
      var dateTime = (null_timestamp as Timestamp) ?? now;
      expect(dateTime, now);
    });

    test('date stays as it is when not null', () {
      /// Testing dart conditional expresions.
      var now = DateTime.now();
      var moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
      var dateTime = moonLanding ?? now;
      expect(dateTime, moonLanding);
    });

    testWidgets('Should contain dateTime in chat widget when specified',
        (WidgetTester tester) async {
      var dateTime = Timestamp.now().toDate();
      await tester.pumpWidget(
          wrapWidget(ChatMessage(text: 'Test message', dateTime: dateTime)));

      log('dateTime: $dateTime');

      var formattedDate =
          '${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, "0")}';

      log('formattedDate: $formattedDate');
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
      final db = MockDatabase();

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
      final db = MockDatabase();
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
      final db = MockDatabase();
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
