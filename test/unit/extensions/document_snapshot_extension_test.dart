// Import the test package and Counter class
import 'package:test/test.dart';
import 'package:adventures_in_chat_app/extensions/extensions.dart';
import '../../mocks/document_snapshot_mocks.dart';

void main() {
  test('Should call toMessage', () {
    var fake = FakeDocumentSnapshot();
    var message = fake.toMessage();

    expect(message.timestamp, DateTime.parse('1969-07-20 20:18:04'));
  });
}
