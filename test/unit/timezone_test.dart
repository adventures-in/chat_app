import 'package:timezone/data/latest.dart';
import 'package:test/test.dart';
import 'package:timezone/timezone.dart';

void main() {
  group('group', () {
    test('test Timezone init', () {
      var local = DateTime.now();
      initializeTimeZones();
      var melbourne = getLocation('Australia/Sydney');
      var now_in_melbourne =
          TZDateTime.parse(melbourne, local.toIso8601String());
      expect(local, now_in_melbourne.toLocal());
      print('time in melbourne:  $now_in_melbourne vs local: $local');
    });

    test('test Datetime timeZoneName', () {
      var local = DateTime.now();
      var timeZoneName = local.timeZoneName;
      print('timeZOneName: $timeZoneName');
    });
  });
}
