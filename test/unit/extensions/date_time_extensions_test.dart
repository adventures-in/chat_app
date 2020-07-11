import 'package:test/test.dart';
import 'package:adventures_in_chat_app/extensions/extensions.dart';

void main() {
  group('DateTime.isSameDate()', () {
    test('returns True when earlier in same day', () {
      var t0 = DateTime.parse('1969-07-20 20:17:04');
      var t1 = DateTime.parse('1969-07-20 08:28:34');

      expect(true, t0.isSameDate(t1));
    });

    test('returns True when later in same day', () {
      var t0 = DateTime.parse('1969-07-20 20:17:04');
      var t1 = DateTime.parse('1969-07-20 23:59:59');

      expect(true, t0.isSameDate(t1));
    });

    test('returns False when compared to null', () {
      var t0 = DateTime.parse('1969-07-20 20:17:04');
      DateTime t1;

      expect(false, t0.isSameDate(t1));
    });

    test('returns False when compared to day of Saturn V rocket', () {
      var t0 = DateTime.parse('1969-07-20 20:17:04');
      var t1 = DateTime.parse('1969-07-16 13:32:34');

      expect(false, t0.isSameDate(t1));
    });

    test('returns False when compared to day after when Buzz got to walk', () {
      var t0 = DateTime.parse('1969-07-20 20:17:04');
      var t1 = DateTime.parse('1969-07-21 02:56:43');

      expect(false, t0.isSameDate(t1));
    });
  });

  group('DateTime.printDate()', () {
    test('returns the date in format day/month/year', () {
      var t0 = DateTime.parse('1969-07-20 20:17:04');
      expect(t0.printDate(), '20/7/1969');
    });
  });
}
