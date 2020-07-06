import 'package:test/test.dart';
import 'package:adventures_in_chat_app/extensions/extensions.dart';

void main() {
  group('DateTime', () {
    test('.isSameDate() returns True when earlier in same day', () {
      var t0 = DateTime.parse('1969-07-20 20:18:04');
      var t1 = DateTime.parse('1969-07-20 08:28:34');

      expect(true, t0.isSameDate(t1));
    });

    test('.isSameDate() returns True when later in same day', () {
      var t0 = DateTime.parse('1969-07-20 20:18:04');
      var t1 = DateTime.parse('1969-07-20 23:59:34');

      expect(true, t0.isSameDate(t1));
    });

    test('.isSameDate() returns False when compared to null', () {
      var t0 = DateTime.parse('1969-07-20 20:18:04');
      DateTime t1;

      expect(false, t0.isSameDate(t1));
    }, skip: true);

    test('.isSameDate() returns False when compared to day before', () {
      var t0 = DateTime.parse('1969-07-20 20:18:04');
      var t1 = DateTime.parse('1969-07-19 23:59:34');

      expect(false, t0.isSameDate(t1));
    });

    test('.isSameDate() returns False when compared to day after', () {
      var t0 = DateTime.parse('1969-07-20 20:18:04');
      var t1 = DateTime.parse('1969-07-21 23:59:34');

      expect(false, t0.isSameDate(t1));
    });
  });
}
