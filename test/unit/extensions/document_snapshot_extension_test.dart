import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test/test.dart';
import 'package:adventures_in_chat_app/extensions/extensions.dart';
import '../../mocks/document_snapshot_mocks.dart';

void main() {
  group('DocumentSnapshot', () {
    test('.toMessage() produces expected DateTime from Timestamp', () {
      // create a fake doc snapshot with a given timestamp
      var fake = FakeDocumentSnapshot.forMessage(
        '123455679',
        'Test Message',
        Timestamp.fromDate(
          DateTime.parse('1969-07-20 20:18:04'),
        ),
      );

      // convert to a message
      var message = fake.toMessage();

      // check the message has the expected timestamp
      expect(message.timestamp, DateTime.parse('1969-07-20 20:18:04'));
    });

    test(
        '.toMessage() creates message with current DateTime when Timestamp is null',
        () {
      // create a fake doc snapshot with null timestamp
      var fake =
          FakeDocumentSnapshot.forMessage('123455679', 'Test Message', null);

      // convert to a message, saving the time before and after
      var before = DateTime.now();
      var message = fake.toMessage();
      var after = DateTime.now();

      // check the message's DateTime was created with the current time
      expect(
        true,
        message.timestamp.isAfter(before) && message.timestamp.isBefore(after),
      );
    });

    test(
        '.toUserItem() creates a UserItem with expected values for displayName & photoURL',
        () {
      // create a fake doc snapshot with null displayName and photoURL
      var fake = FakeDocumentSnapshot();

      // convert to a user item
      var userItem = fake.toUserItem();

      // check displayName and photoURL are null as expected
      expect(userItem.displayName, null);
      expect(userItem.photoURL, null);

      // create a fake doc snapshot with values for displayName and photoURL
      var fake2 = FakeDocumentSnapshot.forUserItem(
          'leon', 'https://example.com/leon.png');
      var userItem2 = fake2.toUserItem();

      // check displayName and photoURL have expected values
      expect(userItem2.displayName, 'leon');
      expect(userItem2.photoURL, 'https://example.com/leon.png');
    });
  });
}
