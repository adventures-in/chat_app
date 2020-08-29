import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Counter App', () {
    final buttonFinder = find.byType('AppleSignInButton');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
      if (const bool.fromEnvironment('EMULATORS')) {
        // set firestore to connect to local emulated firestore
        WidgetsFlutterBinding.ensureInitialized();
        FirebaseFirestore.instance.settings = Settings(
          host: 'localhost:8080',
          sslEnabled: false,
          persistenceEnabled: false,
        );
      }
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        // by not closingthe driver we can continue to interact with the running app
        // driver.close();
      }
    });

    test('sign in', () async {
      await driver.tap(buttonFinder);
    });
  });
}
